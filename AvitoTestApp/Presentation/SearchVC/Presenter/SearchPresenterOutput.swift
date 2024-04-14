//
//  SearchPresenterOutput.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 09.04.2024.
//

protocol SearchPresenterOutput: AnyObject {
    func didSuccessCreateSearchRequest()
    func pushToNextVC(model: CommonEntity?)
}
