//
//  DetailInfoPresenterOutput.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 12.04.2024.
//

import Foundation

protocol DetailInfoPresenterOutput: AnyObject {
    func didSuccessGettingImage(data: Data)
    func didSuccessGettingArtistInfo(data: LookupRequest)
    func didFailureGettingArtistInfo()
}
