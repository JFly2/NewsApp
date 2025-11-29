//
//  APIError.swift
//  NewsApp
//
//

import Foundation

public enum APIError: Error, LocalizedError {
    case badURL
    case transport(Error)
    case httpStatus(Int, Data?)
    case emptyResponse
    case decoding(Error)
    case wrongContentType(String?)
    
    public var errorDescription: String? {
        switch self {
        case .badURL: return "Bad URL."
        case .transport(let e): return e.localizedDescription
        case .httpStatus(let code, _): return "HTTP \(code)."
        case .emptyResponse: return "Empty response."
        case .decoding(let e): return "Decoding failed: \(e)"
        case .wrongContentType(_): return "Unexpected Content Type"
        }
    }
}
