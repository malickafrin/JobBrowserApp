//
//  RemoteJobService.swift
//  JobBrowser
//
//  Created by Afrin Malick on 06/06/26.
//
import Foundation

final class RemoteJobService: JobService {
    private let networkManager: Networking
    
    init(networkMgr: Networking) {
        self.networkManager = networkMgr
    }
    
    func fetchJobs(offset: Int, limit: Int) async throws -> JobResponse {
        try await networkManager.request(JobsEndpoint.jobs(offset: offset, limit: limit))
    }
    
    func searchJobs(searchText: String, offset: Int, limit: Int) async throws -> JobResponse {
        try await networkManager.request(JobsEndpoint.search(query: searchText,
                                                             offset: offset,
                                                             limit: limit))
    }
}
