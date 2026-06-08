//
//  Untitled.swift
//  JobBrowser
//
//  Created by Afrin Malick on 06/06/26.
//
import SwiftUI

struct HeaderView: View {
    
    let job: Job
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            CompanyLogoView(imageURL: job.companyLogoURL)
            VStack(alignment: .leading, spacing: 8) {
                Text(job.title)
                    .font(.headline.bold())
                    .foregroundStyle(.primary)
                
                Text(job.companyName.capitalized)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                
                HStack(spacing: 4) {
                    Image(systemName: "location")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(job.location.joined(separator: ", "))
                        .font(.caption)
                }
                
                Text(job.salaryText ?? "Salary not disclosed")
                    .font(.caption.bold())
                    .foregroundStyle(job.salaryText != nil ? .green.opacity(0.7) : .secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HeaderView(job: Job(title: "iOS Developer", excerpt: "Exceprt", companyName: "Salaria", guid: "1", minSalary: 2250000, maxSalary: 2500000, currency: "INR", description: "Desc", location: ["India"], publishedDate: 12041991, companyLogo: "", employmentType: "Full-time", seniorityLevel: ["Mid-level"]))
}
