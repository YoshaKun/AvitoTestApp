//
//  SearchBuilder.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 06.04.2024.
//

import UIKit

enum SearchBuilder {
    static func build() -> UIViewController {
        let searchService = SearchService()
        let presenter = SearchPresenter(searchService: searchService)
        let viewController = SearchVC(presenter: presenter)
        presenter.output = viewController
        return viewController
    }
}
