//
//  JobResponse+Mock.swift
//  JobBrowser
//
//  Created by Afrin Malick on 07/06/26.
//
@testable import JobBrowser
import Testing

extension JobResponse {
    static func mock(jobs: [Job],
                     offset: Int = 0,
                     limit: Int = 20,
                     totalCount: Int = 0) -> JobResponse {
        JobResponse(jobs: jobs, offset: offset, limit: limit, totalCount: totalCount)
    }
}
