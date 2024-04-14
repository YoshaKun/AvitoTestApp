//
//  DetailInfoPresenterInput.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 12.04.2024.
//

import Foundation

protocol DetailInfoPresenterInput: AnyObject {
    func getImageForDetailVC(urlStr: String)
    func makeLookupRequest(artistId: Int)
}
