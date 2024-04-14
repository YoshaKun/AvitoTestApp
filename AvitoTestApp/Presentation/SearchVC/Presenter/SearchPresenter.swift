//
//  SearchPresenter.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 06.04.2024.
//

import Foundation
import UIKit

final class SearchPresenter {
    
    // MARK: - Public properties
    weak var output: SearchPresenterOutput?
    
    private let searchService: SearchServiceProtocol
    
    // MARK: - Initialization
    init(searchService: SearchServiceProtocol) {
        self.searchService = searchService
    }
}

// MARK: - Implementation of SearchPresenterInput
extension SearchPresenter: SearchPresenterInput {
    func createSearchRequest(
        string: String,
        limit: String?,
        media: MediaType?,
        isExplicit: Bool?,
        lang: LanguageType
    ) {
        searchService.search(
            string: string,
            limit: limit,
            media: media,
            isExplicit: isExplicit,
            lang: lang,
            completion: {
                self.output?.didSuccessCreateSearchRequest()
            }
        )
    }
    
    func getPreviousRequests() -> [String] {
        return searchService.getSearchHistory()
    }
    
    func getModelData() -> CommonResult {
        return searchService.getSearchData()
    }
    
    func pushToDetailInfo(model: CommonEntity?) {
        self.output?.pushToNextVC(model: model)
    }
}
