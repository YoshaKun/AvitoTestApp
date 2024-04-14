//
//  RequestModels.swift
//  AvitoTestApp
//
//  Created by Yosha Kun on 06.04.2024.
//

// MARK: - Request Model Music Entities
struct MusicResult: Decodable {
    let results: [MusicEntity]
}

struct MusicEntity: Decodable {
    let artworkUrl100: String?
    let trackName: String?
    let kind: String?
    let artistName: String
    let artistId: Int
    let trackViewUrl: String
}

// MARK: - Request Model Films Entities
struct FilmResult: Decodable {
    let results: [FilmEntity]
}

struct FilmEntity: Decodable {
    let artworkUrl100: String?
    let trackName: String?
    let artistName: String
    let trackViewUrl: String
    let kind: String?
    let longDescription: String?
    let collectionArtistId: Int?
}

// MARK: - Common Model Entities for views
struct CommonResult: Decodable {
    let results: [CommonEntity]
}

struct CommonEntity: Decodable {
    let artworkUrl100: String?
    let trackName: String?
    let artistName: String
    let artistId: Int
    let trackViewUrl: String
    let kind: String?
    let longDescription: String?
}

// MARK: - Lookup Request model for detail info about an Artist
struct LookupRequest: Decodable {
    let results: [LookupEntity]
}

struct LookupEntity: Decodable {
    let artistType: String
    let artistName: String
    let artistLinkUrl: String
    let primaryGenreName: String
}

enum MediaType {
    case audiobook
    case music
    case movie
    case all
}

enum LanguageType {
    case english
    case russian
    case japanese
}
