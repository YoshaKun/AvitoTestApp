//
//  NetworkProvider.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 06.04.2024.
//

import Foundation

protocol NetworkProvider {
    func get<M: Decodable>(url: String, queryItems: [String: String], completionHandler: @escaping (Result<M, NetworkProviderError>) -> Void)
}

final class NetworkProviderImp {
    static let shared: NetworkProvider = NetworkProviderImp()
    
    private let urlSession: URLSession = .shared
    private let jsonDecoder: JSONDecoder = .init()
    
    private init() {}
}

extension NetworkProviderImp: NetworkProvider {
    func get<M: Decodable>(
        url: String,
        queryItems: [String: String],
        completionHandler: @escaping (Result<M, NetworkProviderError>) -> Void
    ) {
        guard var urlComponents = URLComponents(string: url) else {
            completionHandler(.failure(NetworkProviderError.urlComponentsNotCreated))
            return
        }
        
        urlComponents.queryItems = queryItems.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        
        guard let url = urlComponents.url else {
            completionHandler(.failure(NetworkProviderError.urlNotCreated))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        print("urlRequest = \(urlRequest)")
        urlSession.dataTask(with: urlRequest) { [weak self] data, urlResponse, error in
            guard let self = self else {
                completionHandler(.failure(NetworkProviderError.instanceNotCreated))
                return
            }
            
            if let error = error {
                completionHandler(.failure(NetworkProviderError.urlSesstion(error)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(NetworkProviderError.dataNotFound))
                return
            }
            
            do {
                let model = try self.jsonDecoder.decode(M.self, from: data)
                completionHandler(.success(model))
            } catch {
                completionHandler(.failure(NetworkProviderError.decoding(error)))
            }
            
        }.resume()
    }
}
