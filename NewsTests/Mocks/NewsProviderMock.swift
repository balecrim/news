//
//  NewsProviderMock.swift
//  NewsTests
//
//  Created by Bernardo Alecrim on 10/10/2022.
//

import Foundation
@testable import News

final class NewsProviderMock: NewsProviding {
    private(set) var invocationCount = 0
    private(set) var input: [Int] = []
    var expectedResult: Result<NewsResponse, NewsServiceError>!

    func fetchNews(page: Int) async -> Result<NewsResponse, NewsServiceError> {
        input.append(page)
        invocationCount += 1
        return expectedResult
    }
}
