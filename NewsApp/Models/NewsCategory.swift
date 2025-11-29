//
//  NewsCategory.swift
//  NewsApp
//
//

import Foundation

enum Category: String, CaseIterable, Identifiable {
    case all
    case business
    case sports
    case entertainment
    case health
    case politics
    
    var id: String {rawValue}
    
    var displayName: String {
        switch self {
        case .all: return "All"
        case .business: return "Business"
        case .sports: return "Sports"
        case .entertainment: return "Entertainment"
        case .health: return "Health"
        case .politics: return "Politics"
        }
    }
    
    var apiCategory: String? {
        switch self {
        case .all: return nil
        case .business: return "business"
        case .sports: return "sports"
        case .entertainment: return "entertainment"
        case .health: return "health"
        case .politics: return "general" // treat politics as general + keyword
            
        }
    }
    
    var keyword: String? {
        switch self {
        case .politics: return "politics"
        default: return nil
        }
    }
    
    
}

