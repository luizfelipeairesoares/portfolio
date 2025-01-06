//
//  Creator.swift
//  portfolio
//
//

import Foundation

struct Creator: Codable {

    let name: String
    let role: String

}

struct Creators: Codable {

    let available: Int
    let returned: Int
    let items: [Creator]

}
