//
//  NetworkError.swift
//  portfolio
//
//

import Foundation

public enum NetworkError: Error {
    case invalidRequest
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case error(_ code: Int)
    case serverError
    case encodingError(Swift.Error)
    case decodingError
    case urlSessionFailed(_ error: URLError)
    case unknown
}
