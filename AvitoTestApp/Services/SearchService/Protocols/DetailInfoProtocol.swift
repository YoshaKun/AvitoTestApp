//
//  OIUHJnrg.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 12.04.2024.
//

import Foundation

protocol DetailInfoProtocol: AnyObject {
    func getImageForCell(
        urlStr: String,
        completion: @escaping (Data) -> Void
    )
    func lookupRequest(
        artistID: Int,
        completion: @escaping (LookupRequest) -> Void,
        errorHandler: @escaping () -> Void
    )
}
