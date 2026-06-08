//
//  JobDetailsView.swift
//  JobBrowser
//
//  Created by Afrin Malick on 06/06/26.
//
import SwiftUI

struct JobDetailsView: View {
    let job: Job
    @State private var description: AttributedString = AttributedString("")
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                HeaderView(job: job)
                HighlightsView(job: job)
                
                Text("About \(job.companyName.replacingOccurrences(of: "-", with: " ").capitalized)")
                    .font(.title3.bold())
                    .padding(.top, 8)
                Text(job.excerpt)
                    .font(.body)
                    .padding(.bottom, 8)
                
                Text("Job Description")
                    .font(.title3.bold())
                Text(description)
                    .lineSpacing(4)
            }
        }
        .padding(24)
        .task {
            let result = job.description.htmlAttributedString
            description = result
        }
        .navigationTitle("Job Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
