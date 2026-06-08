//
//  JobBrowserViewModelTests.swift
//  JobBrowser
//
//  Created by Afrin Malick on 07/06/26.
//
import Testing
@testable import JobBrowser

@MainActor
struct JobBrowserViewModelTests {
    
    @Test
    func loadInitialJobs_Success() async {
        let jobs = [Job.mock(id: 1, title: "iOS Engineer"),
                    Job.mock(id: 2, title: "Java Developer")]
        
        let jobResponse = JobResponse.mock(jobs: jobs, offset: 0, limit: 20, totalCount: 2)
        let mockService = MockJobService()
        
        mockService.fetchJobsResults = [.success(jobResponse)]
        
        let vm = JobListViewModel(jobService: mockService)
        
        await vm.loadInitialJobs()
        
        #expect(vm.jobs.count == 2)
        #expect(vm.jobs == jobs)
        #expect(vm.state == .loaded)
        #expect(mockService.fetchJobsCallCount == 1)
    }
    
    @Test
    func loadInitialJobs_EmptyResponse() async {
        let mockService = MockJobService()
        let jobResponse = JobResponse.mock(jobs: [], offset: 0, limit: 0, totalCount: 0)
        
        mockService.fetchJobsResults = [.success(jobResponse)]
        
        let vm = JobListViewModel(jobService: mockService)
        await vm.loadInitialJobs()
        
        #expect(vm.jobs.isEmpty)
        #expect(vm.state == .empty)
    }
    
    @Test
    func loadInitialJobs_Failure() async {

        let mockService = MockJobService()

        mockService.fetchJobsResults = [.failure(
            TestError.networkFailure
        )]

        let sut = JobListViewModel(
            jobService: mockService
        )

        await sut.loadInitialJobs()

        if case .error = sut.state {
            #expect(true)
        } else {
            Issue.record("Expected error state")
        }
    }
    
    @Test
    @MainActor
    func performSearch_Success() async {
        let jobs = [Job.mock(id: 1, title: "iOS Developer")]
        
        let mockService = MockJobService()
        let jobResponse = JobResponse.mock(jobs: jobs, offset: 0, limit: 1, totalCount: 1)
        
        mockService.searchJobsResult = .success(jobResponse)
        let vm = JobListViewModel(jobService: mockService)
        
        await vm.performSearch("iOS Developer")
        
        #expect(vm.jobs == jobs)
        #expect(mockService.searchJobsCallCount == 1)
        #expect(mockService.fetchJobsCallCount == 0)
    }
    
    @Test
    @MainActor
    func performSearch_EmptySearch() async {
        let mockService = MockJobService()
        let jobResponse = JobResponse.mock(jobs: [], offset: 0, limit: 0, totalCount: 0)
        
        mockService.searchJobsResult = .success(jobResponse)
        let vm = JobListViewModel(jobService: mockService)
        
        await vm.performSearch("x12")
        
        #expect(vm.jobs == [])
        #expect(mockService.searchJobsCallCount == 1)
        #expect(mockService.fetchJobsCallCount == 0)
    }
    
    @Test
    @MainActor
    func performSearch_Failure() async {
        let mockService = MockJobService()
        
        mockService.searchJobsResult = .failure(TestError.networkFailure)
        
        let vm = JobListViewModel(jobService: mockService)
        
        await vm.performSearch("Swift")
        
        if case .error = vm.state {
            #expect(true)
        } else {
            Issue.record("Expected error state")
        }
    }
    
    @Test
    func loadNextPage_CurrentJobIsNotLastJob() async {
        let firstPageJobs = [Job.mock(id: 1),Job.mock(id: 2), Job.mock(id: 3)]
        let secondPageJobs = [Job.mock(id: 4),Job.mock(id: 5), Job.mock(id: 6)]
        let firstPageResponse = JobResponse.mock(jobs: firstPageJobs, offset: 0, limit: 3, totalCount: 6)
        let secondPageResponse = JobResponse.mock(jobs: secondPageJobs, offset: 3, limit: 3, totalCount: 0)
        
        let mockService = MockJobService()
        mockService.fetchJobsResults = [.success(firstPageResponse), .success(secondPageResponse)]
        
        let vm = JobListViewModel(jobService: mockService)
        await vm.loadInitialJobs()
        
        await vm.loadNextPage(currentID: firstPageJobs.first!.id)
        
        #expect(vm.jobs.count == 3)
        #expect(mockService.fetchJobsCallCount == 1)
    }
    
    @Test
    func loadNextPage_CurrentJobIsLastJob() async {
        let firstPageJobs = [Job.mock(id: 1),Job.mock(id: 2), Job.mock(id: 3)]
        let secondPageJobs = [Job.mock(id: 4),Job.mock(id: 5), Job.mock(id: 6)]
        let firstPageResponse = JobResponse.mock(jobs: firstPageJobs, offset: 0, limit: 3, totalCount: 6)
        let secondPageResponse = JobResponse.mock(jobs: secondPageJobs, offset: 3, limit: 6, totalCount: 3)
        
        let mockService = MockJobService()
        mockService.fetchJobsResults = [.success(firstPageResponse), .success(secondPageResponse)]
        
        let vm = JobListViewModel(jobService: mockService)
        await vm.loadInitialJobs()
        
        await vm.loadNextPage(currentID: firstPageJobs.last!.id)
        
        #expect(vm.jobs.count == 6)
        #expect(mockService.fetchJobsCallCount == 2)
    }
    
    @Test("Check if duplicate jobs are effectively removed")
    func loadNextPage_CheckDuplicates() async {
        let firstPageJobs = [Job.mock(id: 1),Job.mock(id: 2), Job.mock(id: 3)]
        let secondPageJobs = [Job.mock(id: 4),Job.mock(id: 2), Job.mock(id: 6)]
        let firstPageResponse = JobResponse.mock(jobs: firstPageJobs, offset: 0, limit: 3, totalCount: 6)
        let secondPageResponse = JobResponse.mock(jobs: secondPageJobs, offset: 3, limit: 3, totalCount: 0)
        
        let mockService = MockJobService()
        mockService.fetchJobsResults = [.success(firstPageResponse), .success(secondPageResponse)]
        
        let vm = JobListViewModel(jobService: mockService)
        await vm.loadInitialJobs()
        
        await vm.loadNextPage(currentID: firstPageJobs.last!.id)
        
        #expect(vm.jobs.count == 5)
        #expect(mockService.fetchJobsCallCount == 2)
    }
    
    @Test("No More Pages Available")
    func loadNextPage_NoMorePagesAvailable() async {
        let jobs = [Job.mock(id: 1),Job.mock(id: 2), Job.mock(id: 3)]
        let jobResponse = JobResponse.mock(jobs: jobs, offset: 0, limit: 3, totalCount: 3)
        
        let mockService = MockJobService()
        mockService.fetchJobsResults = [.success(jobResponse)]
        
        let vm = JobListViewModel(jobService: mockService)
        await vm.loadInitialJobs()
        
        await vm.loadNextPage(currentID: jobs.last!.id)
        
        #expect(vm.jobs.count == 3)
        #expect(mockService.fetchJobsCallCount == 1)
    }

    @Test("Pagination Request Failure")
    func loadNextPage_PaginationFailure() async {
        let firstPageJobs = [Job.mock(id: 1),Job.mock(id: 2), Job.mock(id: 3)]
        let firstPageResponse = JobResponse.mock(jobs: firstPageJobs, offset: 0, limit: 3, totalCount: 6)
        
        let mockService = MockJobService()
        mockService.fetchJobsResults = [.success(firstPageResponse), .failure(TestError.networkFailure)]
        
        let vm = JobListViewModel(jobService: mockService)
        await vm.loadInitialJobs()
        
        await vm.loadNextPage(currentID: firstPageJobs.last!.id)
        
        #expect(vm.jobs.count == 3)
        #expect(mockService.fetchJobsCallCount == 2)
        
        if case .error = vm.state {
            #expect(true)
        } else {
            Issue.record("Expected error state")
        }
    }
}

enum TestError: Error {
    case networkFailure
}
