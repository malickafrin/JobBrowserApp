//
//  Untitled.swift
//  JobBrowser
//
//  Created by Afrin Malick on 06/06/26.
//
import SwiftUI

struct HighlightsView: View {
    
    let job: Job
    var body: some View {
        HStack(alignment: .center) {
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: "briefcase")
                Text(job.employmentType)
                    .font(.caption2)
            }
            Spacer()
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: "chart.bar.xaxis.ascending")
                Text(job.seniorityLevel.first ?? "Not specified")
                    .font(.caption2)
            }
            Spacer()
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: "clock")
                Text(job.postedTimeText)
                    .font(.caption2)
            }
        }
        .padding()
        .background (
            RoundedRectangle(cornerRadius: 12)
                .fill(.secondary.opacity(0.05))
                .stroke(Color.secondary, lineWidth: 0.2)
        )
        .frame(maxWidth: .infinity)
    }
        
}


#Preview {
    HighlightsView(job: Job(title: "iOS Developer", excerpt: "Exceprt", companyName: "Salaria", guid: "1", minSalary: 2250000, maxSalary: 2500000, currency: "INR", description: "Desc", location: ["India"], publishedDate: 12041991, companyLogo: "", employmentType: "Full-time", seniorityLevel: ["Mid-level"]))
}
