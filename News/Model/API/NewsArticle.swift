//
//  NewsArticle.swift
//  News
//
//  Created by Bernardo Alecrim on 06/10/2022.
//

import Foundation

struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [NewsArticle]
}

struct NewsArticle: Codable, Hashable, Equatable {
    typealias ID = Int
    var id: ID { self.hashValue }

    let source: NewsSource
    let author: String?
    let title: String
    let url: String
    let urlToImage: String?
    let publishedAt: Date
    let content: String?
}

struct NewsSource: Codable, Hashable, Equatable {
    let id: String?
    let name: String
}
