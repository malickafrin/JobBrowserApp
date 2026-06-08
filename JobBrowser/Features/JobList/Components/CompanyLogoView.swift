//
//  Untitled.swift
//  JobBrowser
//
//  Created by Afrin Malick on 06/06/26.
//
import SwiftUI

struct CompanyLogoView: View {
    let imageURL: URL?
    
    var body: some View {
        Group {
            if let imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                        
                    case .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
                
            } else {
                placeholder
            }
        }
        .frame(width: 50, height: 50)
        .id(imageURL)
    }
    
    private var placeholder: some View {
        Image(systemName: "building.2")
            .font(.title)
    }
}
