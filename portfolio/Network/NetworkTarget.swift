//
//  NetworkTarget.swift
//  portfolio
//
//

import Foundation

public protocol NetworkTarget {

    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var body: NetworkBody { get }
    var headers: [String: String] { get }
    var request: URLRequest? { get }

}

extension NetworkTarget {

    var request: URLRequest? {
        guard var urlComponents = URLComponents(string: baseURL) else { return nil }
        urlComponents.path = "\(urlComponents.path)\(path)"

        guard let finalURL = urlComponents.url else { return nil }

        var request = URLRequest(url: finalURL)

        switch body {
        case .requestParameters(let parameters):
            return request.encoded(parameters: parameters)
        case .JSONRequest(let object):
            return try? request.encoded(encodable: object)
        default:
            break
        }

        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        return request
    }

}
