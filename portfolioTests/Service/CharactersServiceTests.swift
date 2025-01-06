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

    @Test func fectchCharacters() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        createMockURLHandler(resource: "listCharactersResponse")
        let session = URLSession(configuration: configuration)
        var errorRaised: Error?
        var characters: [Characters] = []
        CharactersService(session: session)
            .listCharacters(page: 0)
            .map { $0.data.results }
            .sink { completion in
                switch completion {
                case .failure(let error):
                    errorRaised = error
                case .finished:
                    break
                }
            } receiveValue: { response in
                characters = response
            }
            .store(in: &cancellables)
        #expect(errorRaised == nil)
        #expect(characters.isEmpty == false)
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
