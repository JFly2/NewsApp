//
//  ArticleViewModel.swift
//  NewsApp
//
//

import Foundation

struct ArticleViewModel: Identifiable {
    let article: News.Article
    
    init(article: News.Article) {
        self.article = article
    }
    static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter
    }
    let id = UUID()
    var author: String {
        article.author ?? ""
    }
    var url: URL {
        article.url
    }
    var source: String {
        article.source.name
    }
    var title: String {
        article.title
    }
    var description: String {
        article.description ?? ""
    }
    var imageUrl: URL? {article.urlToImage}
    
    var date: String {
        Self.dateFormatter.string(from: article.publishedAt)
    }
    
    var cleanedTitle: String {
        let t = article.title

    
        let separators = [" - ", " – ", " — "]
        

        for sep in separators {
            if let range = t.range(of: sep, options: .backwards) {
                // Take everything before the separator
                let before = t[..<range.lowerBound]
                return before.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        return t
    }

}

