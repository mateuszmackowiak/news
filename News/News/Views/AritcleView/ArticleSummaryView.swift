//
//  Created on 24/04/2023.
//  
//

import SwiftUI

struct ArticleSummaryView: View {
    let title: String
    let imageURL: URL?
    let desc: String?
    let bookmarked: Bool
    let publishedDate: Date
    let source: String

    let bookmarkAction: @MainActor () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let imageURL {
                HStack {
                    Spacer()
                    CachedAsyncImage(url: imageURL, transaction: Transaction(animation: .easeInOut)) {
                        switch $0 {
                        case .empty:
                            ActivityIndicatorView()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 60)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        @unknown default:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .frame(height: 150)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    Spacer()
                }
            }
            Text(title)
                .font(.body)
                .lineLimit(3)
                .accessibilityIdentifier("title")
            if let desc {
                Text(desc)
                    .lineLimit(2)
                    .font(.caption)
                    .foregroundColor(.secondaryText)
                    .accessibilityIdentifier("desc")
            }
            HStack {
                ArticleCaptionView(source: source,
                                   publishedDate: publishedDate)
                Spacer()
                Button {
                    bookmarkAction()
                } label: {
                    Image(systemName: bookmarked ? "bookmark.fill" : "bookmark")
                        .padding()
                        .contentShape(Rectangle().size(CGSize(width: 44, height: 44)))
                        .accessibilityIdentifier("bookmark")
                }
            }
        }
        .multilineTextAlignment(.leading)
        .padding(.horizontal, 10)
        .padding(.vertical)
        .foregroundColor(.primaryText)
        .frame(maxWidth: .infinity)
    }
}

struct ArticleSummaryView_Preview: PreviewProvider {
    static var previews: some View {
        List {
            Group {
                ArticleSummaryView(title: "'The Lara Croft Collection' For Switch Has Been Rated By The ESRB - Nintendo Life",
                                   imageURL: URL(string: "https://i0.wp.com/9to5mac.com/wp-content/uploads/sites/6/2023/04/malware-virus-scanner-for-mac.jpeg?resize=1200%2C628&quality=82&strip=all&ssl=1")!,
                                   desc: "Two Tomb Raider spin-offs are due out this year",
                                   bookmarked: false,
                                   publishedDate: Date(timeIntervalSince1970: 1682849160),
                                   source: "Nintendo Life",
                                   bookmarkAction: {})

                ArticleSummaryView(title: "'The Lara Croft Collection' For Switch Has Been Rated By The ESRB - Nintendo Life",
                                   imageURL: URL(string: "https://images.nintendolife")!,
                                   desc: "Two Tomb Raider spin-offs are due out this year",
                                   bookmarked: true,
                                   publishedDate: Date(timeIntervalSince1970: 1682849160),
                                   source: "Nintendo Life",
                                   bookmarkAction: {})

                ArticleSummaryView(title: "'The Lara Croft Collection' For Switch Has Been Rated By The ESRB - Nintendo Life",
                                   imageURL: nil,
                                   desc: "Two Tomb Raider spin-offs are due out this year",
                                   bookmarked: false,
                                   publishedDate: Date(timeIntervalSince1970: 1682849160),
                                   source: "Nintendo Life",
                                   bookmarkAction: {})

                ArticleSummaryView(title: "'The Lara Croft Collection' For Switch Has Been Rated By The ESRB - Nintendo Life",
                                   imageURL: URL(string: "https://images.nintendolife.com/59f9897cd722f/1280x720.jpg")!,
                                   desc: "Two Tomb Raider spin-offs are due out this year",
                                   bookmarked: false,
                                   publishedDate: Date(timeIntervalSince1970: 1682849160),
                                   source: "Nintendo Life",
                                   bookmarkAction: {})
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
        }

        .preferredColorScheme(.dark)
    }
}
