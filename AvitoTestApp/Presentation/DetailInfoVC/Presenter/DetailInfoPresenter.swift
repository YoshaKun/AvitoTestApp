//
//  DetailInfoPresenter.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 12.04.2024.
//

import Foundation

final class DetailInfoPresenter {
    
    // MARK: - Public properties
    weak var output: DetailInfoPresenterOutput?
    
    // MARK: - Private
    private let searchService: DetailInfoProtocol
    
    // MARK: - Initialization
    init(searchService: SearchService) {
        self.searchService = searchService
    }
}

extension DetailInfoPresenter: DetailInfoPresenterInput {
    
    // MARK: - Getting image for Search Cell
    func getImageForDetailVC(urlStr: String) {
        searchService.getImageForCell(urlStr: urlStr) { [weak self] data in
            self?.output?.didSuccessGettingImage(data: data)
        }
    }
    
    // MARK: - Getting detail info about Artist
    func makeLookupRequest(artistId: Int) {
        searchService.lookupRequest(artistID: artistId) { [weak self] data in
            self?.output?.didSuccessGettingArtistInfo(data: data)
        } errorHandler: { [weak self] in
            self?.output?.didFailureGettingArtistInfo()
        }
    }
}
