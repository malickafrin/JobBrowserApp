//
//  JobRowView.swift
//  JobBrowser
//
//  Created by Afrin Malick on 06/06/26.
//
import SwiftUI

struct JobRowView: View {

    let job: Job
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text(job.title)
                    .font(.headline.bold())
                    .padding(.trailing, 12)
                
                Text(job.companyName.capitalized)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
                
                Text(job.location.joined(separator: ", "))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                salaryView
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
}

private extension JobRowView {

    @ViewBuilder
    var salaryView: some View {

        if let salary = job.salaryText {
            Text(
                "\(salary)"
            )
            .font(.caption)
            .foregroundStyle(.green)

        } else {

            Text("Salary not specified")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
