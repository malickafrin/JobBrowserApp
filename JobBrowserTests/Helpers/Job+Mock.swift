//
//  Job+Mock.swift
//  JobBrowser
//
//  Created by Afrin Malick on 07/06/26.
//

@testable import JobBrowser
import Testing
import Foundation

extension Job {
    static func mock(id: Int = 1, title: String = "iOS Engineer") -> Job {
        Job(title: title,
            excerpt: "Working at X Holding isn't just a job, it's an opportunity to be a part of something bigger. We are a full-service consulting firm that was founded on the premise of delivering predictable outcomes and high-quality solutions to our clients. Our founders and team members have industry experience and have held senior positions in a wide variety of companies – from emerging startups to large Fortune 50 firms – and we have taken our combined experiences and developed a unique approach that is supported by the principles of deep expertise, integrity, transparency, and dependability.",
            companyName: "X Holding",
            guid: "\(id)",
            minSalary: 2200000,
            maxSalary: 2500000,
            currency: "INR",
            description: "We are seeking a highly motivated and experienced iOS Developer with 8+ years of hands-on experience in developing, maintaining, and deploying native iOS applications. The ideal candidate should possess strong expertise in Swift, SwiftUI, UIKit, API integrations and mobile application architecture, with a focus on delivering high-quality, scalable and performance-driven applications.",
            location: ["India"],
            publishedDate: 1780703975,
            companyLogo: nil,
            employmentType: "Full-Time",
            seniorityLevel: ["Mid-Level"])
    }
}
