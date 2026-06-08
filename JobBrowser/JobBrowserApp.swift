//
//  JobBrowserApp.swift
//  JobBrowser
//
//  Created by Afrin Malick on 06/06/26.
//

import SwiftUI

@main
struct JobBrowserApp: App {
    private let container = AppContainer()
    @State private var router = Router()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                JobListView(
                    viewModel: container.getJobListViewModel()
                )
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .jobDetails(let job):
                        JobDetailsView(
                            job: job
                        )
                    }
                }
                .environment(router)
            }
        }
    }
}

final class AppContainer {
    
    let networking: Networking
    let jobService: JobService
    
    init() {
        
        let networking = NetworkClient()
        
        self.networking = networking

        self.jobService = RemoteJobService(
            networkMgr: networking
        )
        
    }
    
    func getJobListViewModel() -> JobListViewModel {
        
        JobListViewModel(
            jobService: jobService
        )
    }
}

enum Route: Hashable {
    case jobDetails(job: Job)
}

