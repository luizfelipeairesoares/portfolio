//
//  CharacterService.swift
//  portfolio
//
//

import Foundation
import Combine

struct CharactersService {

    private let session: URLSession

    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func listCharacters(page: Int) -> AnyPublisher<MarvelResponse<Characters>, NetworkError> {
        let currentPage = page == 0 ? nil : page
        return NetworkService(with: session)
            .request(endpoint: MarvelAPI.listCharacters(page: currentPage))
    }

    func detailCharacter(id: String) -> AnyPublisher<MarvelResponse<Characters>, NetworkError> {
        return NetworkService(with: session)
            .request(endpoint: MarvelAPI.character(id: id))
    }

    func searchCharacter(searchText: String) -> AnyPublisher<MarvelResponse<Characters>, NetworkError> {
        return NetworkService(with: session)
            .request(endpoint: MarvelAPI.searchCharacters(searchText: searchText))
    }

    func charactersComics(id: String, page: Int) -> AnyPublisher<MarvelResponse<Comic>, NetworkError> {
        let currentPage = page == 0 ? nil : page
        return NetworkService(with: session)
            .request(endpoint: MarvelAPI.charactersComics(id: id, page: currentPage))
    }

}
