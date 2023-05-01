//
//  Created on 24/04/2023.
//  
//

import SwiftUI

struct ArticleDetailsView: View {
    @ObservedObject var viewModel: ArticleDetailsViewModel

    var body: some View {
        VStack {
            WebView(url: viewModel.article.url)
                .padding(.top)
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.background)
        .foregroundColor(.primaryText)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(viewModel.article.title)
                        .font(.title3)
                        .minimumScaleFactor(0.5)
                }
            }

            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.bookmarkAction()
                } label: {
                    Image(systemName: viewModel.isBookmarked() ? "bookmark.fill" : "bookmark")
                        .padding()
                        .contentShape(Rectangle().size(CGSize(width: 32, height: 32)))
                }
            }
        }
    }
}

#if DEBUG
struct ArticleDetailsView_Preview: PreviewProvider {
    private final class BookmarkStorageMock: BookmarkStorage {
        func articles() -> [Article] { [] }
        func store(articles: [Article]) {}
    }
    static var previews: some View {
        NavigationView {
            ArticleDetailsView(viewModel: ArticleDetailsViewModel(article: .sample, bookmarkedCache: BookmarkedCache(bookmarkStorage: BookmarkStorageMock())))
            .navigationBarItems(leading: Button(action: {}, label: { Image(systemName: "chevron.left") }))
        }
        .navigationViewStyle(.stack)
        .preferredColorScheme(.dark)
    }
}
#endif
