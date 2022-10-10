//
//  URLSessionEndpointProvider.swift
//  News
//
//  Created by Bernardo Alecrim on 07/10/2022.
//

import Foundation

final class URLSessionEndpointProvider: EndpointProviding {
    private let decoder: JSONDecoder

    init() {
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func request<T: Decodable>(
        url: URL,
        headerFields: [String: String],
        method: HTTPMethod
    ) async -> Result<T, Error> {
        do {
            var request = URLRequest(url: url)
            headerFields.forEach { request.setValue($1, forHTTPHeaderField: $0) }

            let (data, _) = try await URLSession.shared.data(for: request)
            let decoded = try decoder.decode(T.self, from: data)

            return .success(decoded)
        } catch {
            return .failure(error)
        }
    }
}
