//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Hasan Hasanov on 09.09.22.
//

import Foundation
struct TopHeadLines<Result:Codable>: Codable {
    var status: String?
    var articles: Result?
    var totalResults: Int?
}

// MARK: - Source
struct Source: Codable {
    var id: String?
    var name: String?
}
struct SearchArticle: Codable, Equatable, Identifiable, Hashable {
    static func == (lhs: SearchArticle, rhs: SearchArticle) -> Bool {
        return (lhs.author == rhs.author) && (lhs.articleDescription == rhs.articleDescription) && (lhs.urlToImage == rhs.urlToImage) && (lhs.title == rhs.title)
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(author)
        hasher.combine(articleDescription)
        hasher.combine(urlToImage)
        hasher.combine(title)
    }
    var id = UUID()
    var source: Source?
    var author: String?
    var urlToImage: String?
    var content, title: String?
    var publishedAt: String?
    var articleDescription: String?
    var url: String?

    enum CodingKeys: String, CodingKey {
        case source, author, urlToImage, content, title, publishedAt
        case articleDescription = "description"
        case url
    }
}


