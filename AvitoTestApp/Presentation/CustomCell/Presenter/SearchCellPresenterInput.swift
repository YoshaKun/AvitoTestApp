//
//  SearchCellPresenterInput.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 11.04.2024.
//

import Foundation

protocol SearchCellPresenterInput: AnyObject {
    func getImageForSearchCell(
        urlStr: String,
        completion: @escaping (Data) -> Void
    )
}
