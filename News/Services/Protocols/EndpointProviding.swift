//
//  EndpointProviding.swift
//  News
//
//  Created by Bernardo Alecrim on 06/10/2022.
//

import Foundation

enum HTTPMethod {
    case get
}

protocol EndpointProviding {
    func request<T: Decodable>(
        url: URL,
        headerFields: [String: String],
        method: HTTPMethod
    ) async -> Result<T, Error>
}
