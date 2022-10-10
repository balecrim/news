//
//  FeedViewModelTests.swift
//  NewsTests
//
//  Created by Bernardo Alecrim on 10/10/2022.
//

@testable import News
import XCTest

@MainActor
final class FeedViewModelTests: XCTestCase {
    // The rationale for implicitly unwrapping these is
    // that we want the test class to crash early if we
    // didn't perform setup for these in time before running
    // the tests themselves.
    var feedViewModel: FeedViewModel!
    var newsProviderMock: NewsProviderMock!

    override func setUpWithError() throws {
        self.newsProviderMock = NewsProviderMock()
        self.feedViewModel = FeedViewModel(newsProvider: newsProviderMock)
    }

    func testNewsRetrievedSuccessfully() async throws {
        let article = NewsArticle(
            source: .init(id: "test", name: "Test Runner"),
            author: "Test Author",
            title: "A test execution succeeds",
            url: "https://example.com",
            urlToImage: "https://example.com/dummy.png",
            publishedAt: Date(),
            content: nil
        )

        newsProviderMock.expectedResult = .success(
            NewsResponse(status: "ok", totalResults: 1, articles: [article])
        )

        await feedViewModel.refresh()

        guard case let .loaded(cardModels) = feedViewModel.state else {
            XCTFail("Incorrect state")
            return
        }

        XCTAssertEqual(cardModels.count, 1)

        // Avoiding a crash here by not using cardModels[0].
        // Probably overkill for this simple test, but on a
        // larger codebase, it's pretty annoying when changes
        // cause tests to crash and you need to fix each before
        // getting a full picture of what was broken.
        guard let cardModel = cardModels.first else {
            XCTFail("Missing card model")
            return
        }

        XCTAssertEqual(cardModel.title, article.title)
        XCTAssertEqual(cardModel.author, article.source.name)
        XCTAssertEqual(cardModel.articleURL, article.url)
        XCTAssertEqual(cardModel.imageURL, article.urlToImage)
        XCTAssertEqual(cardModel.preview, article.content)
    }

    func testRefreshFailedMissingKey() async throws {
        newsProviderMock.expectedResult = .failure(.missingApiKey)
        await feedViewModel.refresh()

        guard case let .error(presentableError) = feedViewModel.state else {
            XCTFail("Incorrect state")
            return
        }

        XCTAssertEqual(
            presentableError.friendlyDescription,
            NewsServiceError.missingApiKey.friendlyDescription
        )
        XCTAssertEqual(
            presentableError.icon,
            NewsServiceError.missingApiKey.icon
        )
    }
}
