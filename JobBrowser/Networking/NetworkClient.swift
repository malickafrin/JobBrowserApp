//
//  NetworkClient.swift
//  JobBrowser
//
//  Created by Afrin Malick on 06/06/26.
//
import Foundation

final class NetworkClient: Networking {
    
    private let session: URLSession
    
    private let baseURL = URL(string: "https://himalayas.app")!
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(
        _ endpoint: Endpoint
    ) async throws -> T {

        let maxRetries = 3
        
        for attempt in 1...maxRetries {
            do {
                let url = try makeURL(for: endpoint)

                let (data, response) = try await session.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    
                    do {
                        return try decoder.decode(T.self, from: data)
                    } catch {
                        throw APIError.decodingError
                    }
                    
                case 429, 500...599:
                    throw APIError.serverError(httpResponse.statusCode)
                
                default:
                    throw APIError.serverError(httpResponse.statusCode)
                }
            } catch {
                
                guard shouldRetry(error),
                attempt < maxRetries else {
                    throw mapError(error)
                }
                
                let delay = UInt64(attempt) * 1_000_000_000
                try await Task.sleep(nanoseconds: delay)
            }
        }
        
        throw APIError.invalidResponse
    }
    
    private func makeURL(
        for endpoint: Endpoint
    ) throws -> URL {

        var components = URLComponents(
            url: baseURL.appending(path: endpoint.path),
            resolvingAgainstBaseURL: false
        )

        components?.queryItems = endpoint.queryItems

        guard let url = components?.url else {
            throw APIError.invalidURL
        }

        return url
    }
    
    private func shouldRetry(_ error: Error) -> Bool {

        if let apiError = error as? APIError {
            switch apiError {
            case .serverError(let code):
                return code == 429 || (500...599).contains(code)

            default:
                return false
            }
        }

        if let urlError = error as? URLError {
            switch urlError.code {
            case .timedOut,
                 .networkConnectionLost,
                 .cannotConnectToHost,
                 .notConnectedToInternet,
                 .cannotFindHost,
                 .dnsLookupFailed:
                return true

            default:
                return false
            }
        }

        return false
    }

    private func mapError(_ error: Error) -> APIError {

        if let apiError = error as? APIError {
            return apiError
        }
        
        if error is DecodingError {
            return .decodingError
        }

        return .networkError(error)
    }
}

