//
//  NetworkServiceTests.swift
//  portfolio
//
//

import Testing
import Combine
import Foundation
@testable import portfolio

@Suite class CharacterServiceTests {

    private var cancellables: Set<AnyCancellable> = []

    @Test("CharactersService.listCharacters response is successfull based on mock data.")
    func listCharacters() async throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        createMockURLHandler(resource: "listCharactersResponse")
        let session = URLSession(configuration: configuration)
        var characters: [Characters] = []
        try await confirmation(expectedCount: 1) { confirmation in
            CharactersService(session: session)
                .listCharacters(page: 0)
                .map { $0.data.results }
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        break
                    }
                } receiveValue: { response in
                    characters = response
                    #expect(characters.isEmpty == false)
                    confirmation()
                }
                .store(in: &cancellables)
            try await Task.sleep(for: .seconds(2))
        }
    }

    @Test("CharactersService.detailCharacter response is successfull based on mock data.")
    func detailCharacter() async throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        createMockURLHandler(resource: "listCharactersResponse")
        let session = URLSession(configuration: configuration)
        try await confirmation(expectedCount: 1) { confirmation in
            CharactersService(session: session)
                .detailCharacter(id: "0")
                .map { $0.data.results }
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        break
                    }
                } receiveValue: { response in
                    #expect(response.isEmpty == false)
                    confirmation()
                }
                .store(in: &cancellables)
            try await Task.sleep(for: .seconds(2))
        }
    }

    @Test("CharactersService.charactersComics response is successfull based on mock data.")
    func charactersComics() async throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        createMockURLHandler(resource: "listComicsResponse")
        let session = URLSession(configuration: configuration)
        try await confirmation(expectedCount: 1) { confirmation in
            CharactersService(session: session)
                .charactersComics(id: "0", page: 0)
                .map { $0.data.results }
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print(error)
                    case .finished:
                        break
                    }
                } receiveValue: { response in
                    #expect(response.isEmpty == false)
                    confirmation()
                }
                .store(in: &cancellables)
            try await Task.sleep(for: .seconds(2))
        }
    }

    // MARK: - Private

    private func createMockURLHandler(resource: String) {
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url else {
                throw NetworkError.badRequest
            }
            guard let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            ) else {
                throw NetworkError.badRequest
            }
            if let path = Bundle.main.path(forResource: resource, ofType: "json") {
                let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                return (response, data)
            } else {
                throw NetworkError.decodingError
            }
        }
    }

}
