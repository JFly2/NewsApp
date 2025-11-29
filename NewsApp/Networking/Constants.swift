//
//  Constants.swift
//  NewsApp
//
//

import Foundation


enum Constants {
    
    static let baseUrl = "https://newsapi.org/v2/top-headlines"
    
    static let country = "us"
    
    static let apiKey = "YOUR_API_KEY"
    
    static var endPoint: String {
        Self.baseUrl + "?country=" + Self.country + "&apiKey=" + Self.apiKey
    }
    
}

    

