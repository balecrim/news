//
//  FeedViewModel.swift
//  News
//
//  Created by Bernardo Alecrim on 06/10/2022.
//

import SwiftUI

@MainActor class FeedViewModel: ObservableObject {
    enum State {
        case loading
        case loaded([NewsCardView.Model])
        case error(PresentableError)
    }

    enum SheetState {
        case notPresenting
        case presenting(URL)

        var isPresenting: Bool {
            if case .notPresenting = self { return false }
            return true
        }
    }

    @Published private(set) var state: State = .loading
    @Published private(set) var sheetState: SheetState = .notPresenting
    lazy private(set) var isPresentingSheet = Binding<Bool>(
        get: { self.sheetState.isPresenting },
        set: { _ in self.sheetState = .notPresenting }
    )

    private let newsProvider: NewsProviding

    init(newsProvider: NewsProviding) {
        self.newsProvider = newsProvider
    }

    convenience init() {
        self.init(newsProvider: NewsProvider())
    }

    func refresh() async {
        self.state = .loading
        let newsResponse = await newsProvider.fetchNews(page: 0)

        switch newsResponse {
        case let .success(response):
            self.state = .loaded(mapToModel(articles: response.articles))
        case let .failure(error):
            self.state = .error(error)
        }
    }

    func articleTapped(model: NewsCardView.Model) {
        guard let url = URL(string: model.articleURL) else { return }
        sheetState = .presenting(url)
    }

    private func mapToModel(articles: [NewsArticle]) -> [NewsCardView.Model] {
        articles.map { article in
            let dateString = article.publishedAt.formatted(
                date: .numeric,
                time: .omitted
            )

            return NewsCardView.Model(
                title: article.title,
                preview: article.content,
                imageURL: article.urlToImage,
                articleURL: article.url,
                author: article.source.name,
                publicationDate: dateString
            )
        }
    }
}
