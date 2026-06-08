//
//  JobListViewModel.swift
//  JobBrowser
//
//  Created by Afrin Malick on 06/06/26.
//
import Combine
import Foundation

@MainActor
final class JobListViewModel: ObservableObject {
    
    @Published private(set) var jobs: [Job] = []
    
    @Published var searchText = ""
    @Published private(set) var isSearching = false
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var state: JobListState = .loading
    private var lastPaginatedJobID: Job.ID? = nil
    private let jobService: JobService
    
    private var offset = 0
    private let limit = 20
    private var canLoadMore = true
    @Published var isLoadingMore = false
    
    init(jobService: JobService) {
        self.jobService = jobService
        setupSearch()
    }
    
    func setupSearch() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                
                guard let self else { return }
                
                Task {
                    await self.performSearch(searchText)
                }
            }
            .store(in: &cancellables)
    }
    
    func loadInitialJobs() async {
        state = .loading
        
        offset = 0
        canLoadMore = true
        
        do {
            let jobResponse = try await jobService.fetchJobs(offset: offset,
                                                      limit: limit)
            print(jobResponse.jobs.count)
            self.jobs = jobResponse.jobs
            
            offset += jobResponse.jobs.count
            canLoadMore = offset < jobResponse.totalCount
            
            state = jobs.isEmpty ? .empty : .loaded
        } catch let error {
            print(error)
            state = .error(error.localizedDescription)
        }
    }
    
    func loadNextPage(currentID: String) async {
        guard currentID == jobs.last?.id else { return }
        guard !isLoadingMore else { return }
        guard canLoadMore else { return }
        
        isLoadingMore = true
        defer {
            isLoadingMore = false
        }
        
        do {
            let newJobsResponse = try await jobService.fetchJobs(offset: offset,
                                                                 limit: limit)
            let existingIDS = Set(jobs.map(\.id))
            let newJobs = newJobsResponse.jobs.filter {
                !existingIDS.contains($0.id)
            }
            
            jobs.append(contentsOf: newJobs)
            
            offset += newJobsResponse.jobs.count
            canLoadMore = offset < newJobsResponse.totalCount
            print(offset)
        } catch {
            print(error)
            state = .error(error.localizedDescription)
        }
    }
    
    func performSearch(_ searchText: String) async {
        
        offset = 0
        canLoadMore = true
        isSearching = true
        defer { isSearching = false }
        
        do {
            let response: JobResponse
            
            if searchText.isEmpty {
                response = try await jobService.fetchJobs(
                                                           offset: offset,
                                                           limit: limit)
            } else {
                response = try await jobService.searchJobs(searchText: searchText,
                                                           offset: offset,
                                                           limit: limit)
            }
            
            jobs = response.jobs
            offset += response.jobs.count
            canLoadMore = offset < response.totalCount
            
            state = jobs.isEmpty ? .empty : .loaded
        } catch {
            print(error.localizedDescription)
            state = .error(error.localizedDescription)
        }
        
    }
}

enum JobListState: Equatable {
    case loading
    case loaded
    case error(String)
    case empty
}
