//
//  APIError.swift
//  JobBrowser
//
//  Created by Afrin Malick on 06/06/26.
//
import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    case serverError(Int)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .decodingError:
            return "Unable to decode response"
        case .serverError(let code):
            return "Server error \(code)"
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}

protocol Endpoint {
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
}

enum JobsEndpoint: Endpoint, Equatable {
    
    case jobs(offset: Int, limit: Int)
    case search(query: String, offset: Int, limit: Int)
    
    var path: String {
        switch self {
        case .jobs:
            return "/jobs/api"
        case .search:
            return "/jobs/api/search"
        }
    }
    
    var queryItems: [URLQueryItem] {
        switch self {
        case let .jobs(offset, limit):
            return [
                .init(name: "offset", value: "\(offset)"),
                .init(name: "limit", value: "\(limit)")
            ]
            
        case let .search(query, offset, limit):
            return [
                .init(name: "q", value: query),
                .init(name: "offset", value: "\(offset)"),
                .init(name: "limit", value: "\(limit)")
            ]
        }
    }
}

