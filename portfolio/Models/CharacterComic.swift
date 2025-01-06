//
//  CharacterComic.swift
//  portfolio
//
//

import Foundation

struct CharacterComics: Codable {

    let available: Int
    let items: [CharacterComic]
    let returned: Int

}

struct CharacterComic: Codable, Identifiable {

    var id: String { name }

    let name: String

}
