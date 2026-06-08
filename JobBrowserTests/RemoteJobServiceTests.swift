//
//  RemoteJobServiceTests.swift
//  JobBrowser
//
//  Created by Afrin Malick on 07/06/26.
//
import Testing
@testable import JobBrowser

struct RemoteJobServiceTests {

    @Test
    @MainActor
    func searchJobs_ForwardsRequestToNetworkLayer() async throws {

        let jobs = [Job.mock()]
        let mockNetwork = MockNetworkClient()

        let expectedResponse = JobResponse.mock(jobs: jobs)
        mockNetwork.response = expectedResponse

        let mockService = RemoteJobService(networkMgr: mockNetwork)
        let response = try await mockService.searchJobs(
            searchText: "ios",
            offset: 0,
            limit: 20
        )

        #expect(response.jobs.count == expectedResponse.jobs.count)
        #expect(mockNetwork.requestedEndPoint != nil)
        #expect(
            mockNetwork.requestedEndPoint ==
            .search(query: "ios", offset: 0, limit: 20)
        )
    }
    
    @Test
    @MainActor
    func fetchJobs_ForwardsRequestToNetworkLayer() async throws {

        let jobs = [Job.mock()]
        let mockNetwork = MockNetworkClient()

        let expectedResponse = JobResponse.mock(jobs: jobs)
        mockNetwork.response = expectedResponse

        let service = RemoteJobService(networkMgr: mockNetwork)

        let response = try await service.fetchJobs(
            offset: 0,
            limit: 20
        )

        #expect(response.jobs.count == expectedResponse.jobs.count)
        #expect(mockNetwork.requestedEndPoint != nil)
        #expect(
            mockNetwork.requestedEndPoint ==
            .jobs(offset: 0, limit: 20)
        )
    }
}
