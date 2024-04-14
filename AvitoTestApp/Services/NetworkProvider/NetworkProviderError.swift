//
//  NetworkProviderError.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 06.04.2024.
//

enum NetworkProviderError: Error {
    case instanceNotCreated
    case urlComponentsNotCreated
    case urlNotCreated
    case urlSesstion(Error)
    case dataNotFound
    case decoding(Error)
}
