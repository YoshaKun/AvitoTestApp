//
//  SearchPresenterInput.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 09.04.2024.
//

import Foundation

protocol SearchPresenterInput {
    func getPreviousRequests() -> [String]
    func createSearchRequest(
        string: String,
        limit: String?,
        media: MediaType?,
        isExplicit: Bool?,
        lang: LanguageType
    )
    func getModelData() -> CommonResult
    func pushToDetailInfo(
        model: CommonEntity?
    )
}
