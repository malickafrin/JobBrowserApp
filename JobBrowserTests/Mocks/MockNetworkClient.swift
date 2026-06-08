//
//  MockNetworkClient.swift
//  JobBrowser
//
//  Created by Afrin Malick on 07/06/26.
//
@testable import JobBrowser
import Testing

final class MockNetworkClient: Networking {
    
    var requestedEndPoint: JobsEndpoint?
    var response: Any?
    
    func request<T>(_ endpoint: any Endpoint) async throws -> T where T : Decodable {
        requestedEndPoint = endpoint as? JobsEndpoint
        return response as! T
    }
}
