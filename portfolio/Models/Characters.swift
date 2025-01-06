//
//  Characters.swift
//  portfolio
//
//

import Foundation

struct Characters: Codable {

    let id: Int
    let name: String?
    let desc: String?
    let resourceURI: String?
    let thumbnail: MarvelImage?
    let comics: CharacterComics

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case desc = "description"
        case resourceURI
        case thumbnail
        case comics
    }

}
