//
//  Created on 24/04/2023.
//  
//

import SwiftUI

struct ArticleDetailsView: View {
    let article: Article
    let bookmarked: Bool = false

    var body: some View {
        VStack {
            WebView(url: article.url)
                .padding(.top)
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color.background)
        .foregroundColor(.primaryText)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text(article.title)
                        .font(.title3)
                        .minimumScaleFactor(0.5)
                }
            }

            ToolbarItem(placement: .primaryAction) {
                Button {
//                    bookmarkAction()
                } label: {
                    Image(systemName: bookmarked ? "bookmark.fill" : "bookmark")
                        .padding()
                        .contentShape(Rectangle().size(CGSize(width: 32, height: 32)))
                }
            }
        }
    }
}

#if DEBUG
struct ArticleDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleDetailsView(article: .sample)
            .navigationBarItems(leading: Button(action: {}, label: { Image(systemName: "chevron.left") }))
        }
        .navigationViewStyle(.stack)
        .preferredColorScheme(.dark)
    }
}
#endif
