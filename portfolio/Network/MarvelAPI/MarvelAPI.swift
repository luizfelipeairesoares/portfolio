//
//  MarvelAPI.swift
//  portfolio
//
//

import Foundation
import CryptoKit

enum MarvelAPI {

    case listCharacters(page: Int?)
    case character(id: String)
    case searchCharacters(searchText: String)
    case charactersComics(id: String, page: Int?)

}

extension MarvelAPI: NetworkTarget {

    var baseURL: String {
        return "https://gateway.marvel.com/v1/public/"
    }
    
    var path: String {
        switch self {
        case .listCharacters, .searchCharacters:
            return "characters"
        case .character(let id):
            return "characters/\(id)"
        case .charactersComics(let id, _):
            return "characters/\(id)/comics"
        }
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var body: NetworkBody {
        var apiParameters = generateAPIParameters()
        switch self {
        case .listCharacters(let page), .charactersComics(_, let page):
            if let currentPage = page {
                apiParameters["offset"] = "\(currentPage)"
            }
            return .requestParameters(parameters: apiParameters)
        case .searchCharacters(let searchText):
            apiParameters["name"] = searchText
            return .requestParameters(parameters: apiParameters)
        default:
            return .requestParameters(parameters: apiParameters)
        }
    }
    
    var headers: [String: String] {
        return [:]
    }

    // MARK: - Private

    private func generateAPIParameters() -> [String: Any] {
        let timestamp = "\(Date().timeIntervalSince1970)"
        guard let apiKey = md5ApiKey(timestamp: timestamp) else { return [:] }
        let publicKey = "bb3f83ba691ebe2e30d734b8ad3b7ff5"
        return [
            "ts": timestamp,
            "apikey": publicKey,
            "hash": apiKey
        ]
    }

    private func md5ApiKey(timestamp: String) -> String? {
        let privateKey = "c51a02488f0b3c7191c525ce4450dacee6f2ab97"
        let publicKey = "bb3f83ba691ebe2e30d734b8ad3b7ff5"
        let hash = "\(timestamp)\(privateKey)\(publicKey)"
        guard let data = hash.data(using: .utf8) else { return nil }
        let digest = Insecure.MD5.hash(data: data)
        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }

}
