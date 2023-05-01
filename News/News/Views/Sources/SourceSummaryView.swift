//
//  SourceSummaryView.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import SwiftUI

struct SourceSummaryView: View {
    let name: String
    let desc: String
    let category: String
    let language: String
    let country: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(name)
                .font(.body)
                .lineLimit(3)
                .accessibilityIdentifier("name")
            Text(desc)
                .lineLimit(2)
                .font(.caption)
                .foregroundColor(.secondaryText)
                .accessibilityIdentifier("desc")
            HStack(spacing: 10) {
                Text(category)
                    .foregroundColor(.accentColor)
                    .accessibilityIdentifier("category")

                Spacer()

                Text(language)
                    .accessibilityIdentifier("language")

                Text(country)
                    .accessibilityIdentifier("country")
            }
            .foregroundColor(.secondaryText)
            .font(.caption)
        }
        .multilineTextAlignment(.leading)
        .padding(.horizontal, 10)
        .padding(.vertical)
        .foregroundColor(.primaryText)
        .frame(maxWidth: .infinity)
    }
}

struct SourceSummaryView_Preview: PreviewProvider {
    static var previews: some View {
        SourceSummaryView(
            name: "ABC News",
            desc: "Your trusted source for breaking news, analysis, exclusive interviews, headlines, and videos at ABCNews.com.",
            category: "general",
            language: "en",
            country: "us")
        .preferredColorScheme(.dark)
    }
}
