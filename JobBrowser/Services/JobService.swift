//
//  JobService.swift
//  JobBrowser
//
//  Created by Afrin Malick on 06/06/26.
//
import Foundation

protocol JobService {
    func fetchJobs(offset: Int, limit: Int) async throws -> JobResponse
    func searchJobs(searchText: String, offset: Int, limit: Int) async throws -> JobResponse
}

