//
//  String+Extension.swift
//  JobBrowser
//
//  Created by Afrin Malick on 06/06/26.
//
import Foundation
import UIKit
import SwiftUI

extension String {

    var htmlAttributedString: AttributedString {
        
        let styledHTML = """
        <style>
        * { font-family: -apple-system, 'Helvetica Neue', sans-serif !important; }
        body, p { font-size: 17px; line-height: 1.7; margin-bottom: 14px; margin-top: 0; }
        h1, h2 { font-size: 17px; font-weight: 700; margin-top: 16px; margin-bottom: 6px; }
        h3, h4, h5, h6 { font-size: 17px; font-weight: 600; margin-top: 16px; margin-bottom: 6px; }
        ul, ol { margin-bottom: 14px; padding-left: 20px; }
        li { font-size: 17px; line-height: 1.8; margin-bottom: 8px; }
        a { color: #007AFF; text-decoration: none; }
        strong, b { font-weight: 600; }
        </style>
        \(self)
        """
        
        guard let styledData = styledHTML.data(using: .utf8) else { return AttributedString(self) }
        
        do {
            let nsAttributedString = try NSAttributedString(
                data: styledData,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            return AttributedString(nsAttributedString)
        } catch {
            return AttributedString(self)
        }
    }
}
