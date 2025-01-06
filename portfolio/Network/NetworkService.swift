//
//  NetworkService.swift
//  portfolio
//
//

import Foundation
import Combine
import OSLog

public protocol NetworkServiceProtocol {
    func request<T: Decodable>(endpoint: NetworkTarget) async throws -> T
    func request<T: Decodable>(endpoint: NetworkTarget) -> AnyPublisher<T, NetworkError>
}

final public class NetworkService: NetworkServiceProtocol {

    public let urlSession: URLSession

    public init(with session: URLSession = .shared) {
        self.urlSession = session
    }

    public func request<T>(endpoint: any NetworkTarget) async throws -> T where T : Decodable {
        guard let request = endpoint.request else {
            throw NetworkError.badRequest
        }
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.unauthorized
        }
        guard let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.decodingError
        }
        return decoded
    }
    
    public func request<T>(endpoint: any NetworkTarget) -> AnyPublisher<T, NetworkError> where T : Decodable {
        guard let request = endpoint.request else {
            return Fail(error: NetworkError.badRequest)
                .eraseToAnyPublisher()
        }
        Logger.network.debug("[API REQUEST] - \(request.url?.absoluteString ?? "")")
        return urlSession.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                    Logger.network.debug("[API RESPONSE] - unauthorized")
                    throw NetworkError.unauthorized
                }
                Logger.network.debug("[API RESPONSE] - HTTP Status Code: \(response.statusCode)")
                Logger.network.debug("[API RESPONSE] - Response body: \(String(data: data, encoding: .utf8) ?? "")")
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> NetworkError in
                if error is DecodingError {
                    Logger.network.debug("[API RESPONSE] - \(error.localizedDescription)")
                    return NetworkError.decodingError
                } else if let error = error as? NetworkError {
                    Logger.network.debug("[API RESPONSE] - \(error.localizedDescription)")
                    return error
                } else {
                    Logger.network.debug("[API RESPONSE] - unknown error mapped")
                    return NetworkError.unknown
                }
            }
            .eraseToAnyPublisher()
    }

}
