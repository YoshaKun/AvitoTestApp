//
//  SearchCellPresenter.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 11.04.2024.
//

import Foundation

final class SearchCellPresenter {
    
    // MARK: - properties
    private var searchService: CollectionViewCellProtocol = SearchService()
}

extension SearchCellPresenter: SearchCellPresenterInput {
    
    // MARK: - Getting image for Search Cell
    func getImageForSearchCell(urlStr: String, completion: @escaping (Data) -> Void) {
        searchService.getImageForCell(urlStr: urlStr, completion: completion)
    }
}
