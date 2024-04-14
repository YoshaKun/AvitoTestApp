//
//  SearchServiceProtocol.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 11.04.2024.
//

import Foundation

protocol SearchServiceProtocol {
    func search(
        string: String,
        limit: String?,
        media: MediaType?,
        isExplicit: Bool?,
        lang: LanguageType,
        completion: @escaping () -> Void
    )
    func getSearchHistory() -> [String]
    func getSearchData() -> CommonResult
}
