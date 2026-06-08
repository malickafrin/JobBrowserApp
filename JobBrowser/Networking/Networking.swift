//
//  Networking.swift
//  JobBrowser
//
//  Created by Afrin Malick on 06/06/26.
//
protocol Networking {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}
