//
//  NewsViewModel.swift
//  NewsApp
//
//

import Foundation
import Combine

class NewsViewModel: ObservableObject {
    @Published var articles: [ArticleViewModel] = []
    
    @Published var selectedCountry:Country = Country.country(code: Constants.country){
        didSet {
            getNews()
        }
    }
    
    @Published var selectedCategory: Category = .all {
        didSet {
            getNews()
        }
    }

    
    var customEndpoint: String {
       
        guard var components = URLComponents(string: Constants.baseUrl) else {
            print("Invalid base Url:", Constants.baseUrl)
            return ""
        }
      
        var query: [URLQueryItem] = [
            URLQueryItem(name: "country", value: selectedCountry.code.lowercased()),
            URLQueryItem(name: "apiKey", value: Constants.apiKey)
        ]
        
        if selectedCategory != .all {
            query.append(URLQueryItem(name:"category", value: selectedCategory.rawValue))
        }
        
         components.queryItems = query
        
        guard let finalURL = components.url else {
                print("Failed to build URL from components")
                return ""
            }

            let urlString = finalURL.absoluteString
            print("Request URL:", urlString)
            return urlString
    }
    
    func getNews(){
        APIClient.shared.fetch(customEndpoint){(result: Result<News,APIError>) in
            Task { @MainActor in
                switch result {
                case .success(let news):
                        self.articles = news.articles.map(ArticleViewModel.init)
                case .failure(let error):
                    print("Failed to fetch news:", error.localizedDescription)
                }
            }
        }
    }
}
