//
//  MarvelResponse.swift
//  portfolio
//
//

import Foundation

struct MarvelResponse<T:Codable>: Codable {

    let code: Int
    let status: String
    let data: MarvelData<T>

}

struct MarvelData<T: Codable>: Codable {

    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [T]

}
