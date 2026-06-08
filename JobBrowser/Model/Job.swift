//
//  Job.swift
//  JobBrowser
//
//  Created by Afrin Malick on 06/06/26.
//
import Foundation

struct JobResponse: Codable {
    let jobs: [Job]
    let offset: Int
    let limit: Int
    let totalCount: Int
}

struct Job: Codable, Identifiable, Hashable {
    var id: String { guid }

    let title: String
    let excerpt: String
    let companyName: String
    let guid: String
    
    let minSalary: Double?
    let maxSalary: Double?
    let currency: String
    let description: String
    
    let location: [String]
    let publishedDate: TimeInterval
    let companyLogo: String?
    let employmentType: String
    let seniorityLevel: [String]
    
    enum CodingKeys: String, CodingKey {
        case title
        case excerpt
        case guid
        case minSalary
        case maxSalary
        case currency
        case description
        case companyLogo
        case employmentType
        case seniorityLevel = "seniority"
        case companyName = "companySlug"
        case location = "locationRestrictions"
        case publishedDate = "pubDate"
    }
}

extension Job {

    var salaryText: String? {

        guard let minSalary,
              let maxSalary else {
            return nil
        }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0

        let min = formatter.string(
            from: NSNumber(value: minSalary)
        ) ?? "\(minSalary)"

        let max = formatter.string(
            from: NSNumber(value: maxSalary)
        ) ?? "\(maxSalary)"

        return "\(currency) \(min) - \(max)"
    }
    
    var companyLogoURL: URL? {
        guard let companyLogo,
                !companyLogo.isEmpty,
                companyLogo.hasPrefix("http") else {
            return nil
        }
        
        return URL(string: companyLogo)
    }
    
    var postedTimeText: String {
        
        let date = Date(timeIntervalSince1970: publishedDate)
        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        
        return " Posted \(formatter.localizedString(for: date, relativeTo: Date()))"
    }
}
