//
//  NetworkBody.swift
//  portfolio
//
//

import Foundation

public enum NetworkBody {

    case plainRequest
    case requestParameters(parameters: [String: Any])
    case JSONRequest(Encodable)

}
