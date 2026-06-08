//
//  MockJobService.swift
//  JobBrowser
//
//  Created by Afrin Malick on 07/06/26.
//
@testable import JobBrowser
import Testing
import Foundation

final class MockJobService: JobService {
    var fetchJobsResults: [Result <JobResponse, Error>] = []
    var searchJobsResult: Result <JobResponse, Error>?
    
    private(set) var fetchJobsCallCount = 0
    private(set) var searchJobsCallCount = 0
    private(set) var fetchPaginatedJobsCallCount = 0
    
    private(set) var receivedOffset: Int?
    private(set) var receivedLimit: Int?
    private(set) var receivedSearchText: String?
    
    func fetchJobs(offset: Int, limit: Int) async throws -> JobBrowser.JobResponse {
        fetchJobsCallCount += 1
        
        receivedOffset = offset
        receivedLimit = limit
        
        guard !fetchJobsResults.isEmpty else {
            fatalError("fetchJobResult not configured")
        }
        
        return try fetchJobsResults.removeFirst().get()
    }
    
    func searchJobs(searchText: String, offset: Int, limit: Int) async throws -> JobBrowser.JobResponse {
        searchJobsCallCount += 1
        
        guard let searchJobsResult else {
            fatalError("searchJobsResult not configured")
        }
        
        return try searchJobsResult.get()
    }
}
