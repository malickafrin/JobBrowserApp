//
//  JobListView.swift
//  JobBrowser
//
//  Created by Afrin Malick on 06/06/26.
//
import SwiftUI

struct JobListView: View {

    @StateObject private var viewModel: JobListViewModel

    init(viewModel: JobListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {

        Group {
            switch viewModel.state {
            case .loading:
                ProgressView()

            case .empty:
                ContentUnavailableView(
                    "No Jobs Found",
                    systemImage: "briefcase",
                    description: Text("Try a different keyword or clear your search.")
                )

            case .error(let message):
                ContentUnavailableView(
                    "Something went wrong",
                    systemImage: "exclamationmark.triangle",
                    description: Text(message)
                )

            case .loaded:
                JobsListView(viewModel: viewModel)
                
            }
        }
        .task {
            if viewModel.jobs.isEmpty {
                await viewModel.loadInitialJobs()
            }
        }
        .onChange(of: viewModel.isLoadingMore) { oldValue, newValue in
        }
        .navigationTitle("Jobs")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always))
        .disabled(viewModel.state == .loading)
    }
}

struct JobsListView: View {
    @ObservedObject var viewModel: JobListViewModel
    @Environment(Router.self) var router: Router

    var body: some View {
        List {
            ForEach(viewModel.jobs, id: \.id) { job in
                JobRowView(job: job)
                    .onAppear {
                        Task {
                            await viewModel.loadNextPage(currentID: job.id)
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
                    .contentShape(Rectangle())
                    .onTapGesture {
                        router.navigate(to: .jobDetails(job: job))
                    }
            }
        }
        .overlay(alignment: .bottom) {
            if viewModel.isLoadingMore {
                ProgressView()
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
            }
        }
    }
}

#Preview {
//    JobListView()
}

