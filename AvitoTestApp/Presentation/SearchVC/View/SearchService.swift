//
//  SearchService.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 06.04.2024.
//

import Foundation

final class SearchService {
    
    // MARK: - init NetworkProvider
    let networkProvider = NetworkProviderImp.shared
    
    // MARK: - Public model Data
    var modelMusicData = MusicResult(results: [])
    var modelFilmsData = FilmResult(results: [])
    var modelCommonData = CommonResult(results: [])
    var lookupData: LookupRequest?
}

// MARK: - Implementation of CollectionViewCellProtocol
extension SearchService: CollectionViewCellProtocol {
    
    // MARK: - Get image for Cell
    func getImageForCell(
        urlStr: String,
        completion: @escaping (Data) -> Void
    ) {
        let components = URLComponents(string: "\(urlStr)")
        guard let url = components?.url else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data else {
                AlertHelper.showAlert(withMessage: "Error: \(String(describing: error?.localizedDescription))")
                return }
            completion(data)
        }
        task.resume()
    }
}

// MARK: - Implementation of SearchServiceProtocol
extension SearchService: SearchServiceProtocol {
    
    // MARK: - SearchServiceProtocol Search some text from searchBar
    func search(
        string: String,
        limit: String?,
        media: MediaType?,
        isExplicit: Bool?,
        lang: LanguageType,
        completion: @escaping () -> Void
    ) {
        // "valueParam" needs implement as sum of lowercased strings where " " changing to "+", example: "jack+johnson"
        let firstQuery = "term"
        let firstValue = convertToValueParam(string)
        let secondQuery = "limit"
        let secondValue = limit ?? "30" // by "default" (nil) limit will be 50. Limit can be show from 1 to 200 results
        let thirdQuery = "media"
        var thirdValue = "all"
        let fourthQuery = "explicit"
        var fourthValue = "Yes"
        let fithQuery = "country"
        var fithValue = "us"
        
        switch media {
        case .music:
            thirdValue = "music"
        case .movie:
            thirdValue = "movie"
        case .all:
            thirdValue = "all"
        default:
            thirdValue = "all"
        }
        
        if isExplicit == false {
            fourthValue = "No"
        }
        
        switch lang {
        case .english:
            fithValue = "us"
        case .russian:
            fithValue = "ru"
        case .japanese:
            fithValue = "jp"
        }
        
        networkProvider.get(
            url: "https://itunes.apple.com/search",
            queryItems: [
                "\(firstQuery)": "\(firstValue)",
                "\(secondQuery)": "\(secondValue)",
                "\(thirdQuery)": "\(thirdValue)",
                "\(fourthQuery)": "\(fourthValue)",
                "\(fithQuery)": "\(fithValue)"
            ],
            completionHandler: { (result: Result<MusicResult, NetworkProviderError>) in
                switch result {
                case .success(let requestResult):
                    completion()
                    self.modelMusicData = requestResult
                    self.saveSearchRequest(string: string)
                case .failure(let error):
                    print(error)
                }
            }
        )
        networkProvider.get(
            url: "https://itunes.apple.com/search",
            queryItems: [
                "\(firstQuery)": "\(firstValue)",
                "\(secondQuery)": "\(secondValue)",
                "\(thirdQuery)": "\(thirdValue)",
                "\(fourthQuery)": "\(fourthValue)",
                "\(fithQuery)": "\(fithValue)"
            ],
            completionHandler: { (result: Result<FilmResult, NetworkProviderError>) in
                switch result {
                case .success(let requestResult):
                    completion()
                    self.modelFilmsData = requestResult
                    self.saveSearchRequest(string: string)
                case .failure(let error):
                    AlertHelper.showAlert(withMessage: "Can't get Films data")
                    print(error)
                }
            }
        )
    }
    
    // MARK: - SearchServiceProtocol Get previous 5 search text requests from UserDefaults
    func getSearchHistory() -> [String] {
        guard var requestHistory = UserDefaults.standard.object(forKey: "requestHistory") as? [String] else {
            return []
        }
        return requestHistory
    }
    
    // MARK: - Get Search Responder
    func getSearchData() -> CommonResult {
        var musModel: [CommonEntity] = []
        var filmModel: [CommonEntity] = []
        var allModel: [CommonEntity] = []
        
        var littleMusicModel = modelMusicData.results
        var littleFilmModel = modelFilmsData.results
        
        for entity in littleMusicModel {
            let newElement = CommonEntity(
                artworkUrl100: entity.artworkUrl100,
                trackName: entity.trackName,
                artistName: entity.artistName,
                artistId: entity.artistId,
                trackViewUrl: entity.trackViewUrl,
                kind: entity.kind,
                longDescription: nil
            )
            musModel.append(newElement)
        }
        
        for entity in littleFilmModel {
            let newElement = CommonEntity(
                artworkUrl100: entity.artworkUrl100,
                trackName: entity.trackName,
                artistName: entity.artistName,
                artistId: entity.collectionArtistId ?? 000,
                trackViewUrl: entity.trackViewUrl,
                kind: entity.kind,
                longDescription: entity.longDescription
            )
            filmModel.append(newElement)
        }
        
        if UserDefaults.standard.bool(forKey: "sortByMusic") == true {
            modelCommonData = CommonResult(results: musModel)
        } else if UserDefaults.standard.bool(forKey: "sortByMovies") == true {
            modelCommonData = CommonResult(results: filmModel)
        } else {
            allModel = musModel + filmModel
            modelCommonData = CommonResult(results: allModel)
        }
        return self.modelCommonData
    }
    
    // MARK: - Convert usualy string to value parametr of QueryItem
    private func convertToValueParam(_ inputString: String) -> String {
        let lowercaseString = inputString.lowercased()
        let convertedString = lowercaseString.replacingOccurrences(of: " ", with: "+")
        return convertedString
    }
    
    // MARK: - Save search request in UserDefaults
    private func saveSearchRequest(string: String) {
        guard !string.isEmpty else { return }
        
        let defaults = UserDefaults.standard
        
        guard var requestHistory = defaults.object(forKey: "requestHistory") as? [String] else {
            let array = [string]
            defaults.set(array, forKey: "requestHistory")
            return
        }
        if requestHistory.count < 5 {
            requestHistory.insert(string, at: 0)
            defaults.set(requestHistory, forKey: "requestHistory")
        } else if requestHistory.count == 5 {
            requestHistory.removeLast()
            requestHistory.insert(string, at: 0)
            defaults.set(requestHistory, forKey: "requestHistory")
        }
    }
}

extension SearchService: DetailInfoProtocol {
    
    func lookupRequest(
        artistID: Int,
        completion: @escaping (LookupRequest) -> Void,
        errorHandler: @escaping () -> Void
    ) {
        let artId = artistID
        print("artId = \(artId)")
        networkProvider.get(
            url: "https://itunes.apple.com/lookup",
            queryItems: [
                "id": "\(artId)"
            ],
            completionHandler: { (result: Result<LookupRequest, NetworkProviderError>) in
                switch result {
                case .success(let requestResult):
                    completion(requestResult)
                    self.lookupData = requestResult
                case .failure(let error):
                    errorHandler()
                    AlertHelper.showAlert(withMessage: "Can't get Lookup Artist data")
                    print(error)
                }
            }
        )
    }
}
