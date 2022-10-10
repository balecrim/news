//
//  NewsService.swift
//  News
//
//  Created by Bernardo Alecrim on 06/10/2022.
//

import Foundation
import SwiftUI

enum NewsServiceError: Swift.Error {
    case failedToGetURL
    case missingApiKey
    case urlSessionError(Swift.Error)
}

protocol NewsProviding {
    func fetchNews(page: Int) async -> Result<NewsResponse, NewsServiceError>
}

final class NewsProvider: NewsProviding {
    private let endpointProvider: EndpointProviding
    private let secretsProvider: SecretsProviding

    init(
        endpointProvider: EndpointProviding,
        secretsProvider: SecretsProviding
    ) {
        self.endpointProvider = endpointProvider
        self.secretsProvider = secretsProvider
    }

    convenience init() {
        self.init(
            endpointProvider: URLSessionEndpointProvider(),
            secretsProvider: SecretsProvider()
        )
    }

    func fetchNews(page: Int) async -> Result<NewsResponse, NewsServiceError> {
        var urlComponents = URLComponents(string: "https://newsapi.org/v2/top-headlines")
        urlComponents?.queryItems = [URLQueryItem(name: "sources", value: "the-wall-street-journal")]

        guard let url = urlComponents?.url else {
            return .failure(NewsServiceError.failedToGetURL)
        }

        guard let apiKey = secretsProvider.apiKey else {
            return .failure(NewsServiceError.missingApiKey)
        }

        let headerFields = [
            "x-api-key": apiKey
        ]

        return await endpointProvider.request(
            url: url,
            headerFields: headerFields,
            method: .get
        )
        .mapError({ error in
            NewsServiceError.urlSessionError(error)
        })
    }
}

extension NewsServiceError: PresentableError {
    var icon: Image {
        Image(systemName: "exclamationmark.triangle.fill")
    }

    var friendlyDescription: String {
        switch self {
        case .failedToGetURL:
            return "Failed to build a proper api key"
        case .missingApiKey:
            return "Missing API key. Did you set it up in Secrets.plist?"
        case let .urlSessionError(error):
            return "URLSession error: \(error.localizedDescription)"
        }
    }
}
