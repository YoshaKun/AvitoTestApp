//
//  SearchServiceProtocol.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 11.04.2024.
//

import Foundation

protocol CollectionViewCellProtocol: AnyObject {
    func getImageForCell(
        urlStr: String,
        completion: @escaping (Data) -> Void
    )
}
