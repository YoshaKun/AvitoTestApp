//
//  DetailInfoBuilder.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 12.04.2024.
//

import UIKit

enum DetailInfoBuilder {
    static func build(model: CommonEntity?) -> UIViewController {
        let searchService = SearchService()
        let presenter = DetailInfoPresenter(searchService: searchService)
        let viewController = DetailInfoVC(dataModel: model, presenter: presenter)
        presenter.output = viewController
        return viewController
    }
}
