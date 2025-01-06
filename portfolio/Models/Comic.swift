//
//  Comic.swift
//  portfolio
//
//

import Foundation

struct Comic: Codable, Identifiable {

    let id: Int
    let digitalId: Int
    let title: String
    let issueNumber: Int
    let description: String
    let isbn: String
    let pageCount: Int
    let thumbnail: MarvelImage?
    let creators: Creators

}
