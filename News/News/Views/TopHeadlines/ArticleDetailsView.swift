//
//  Created on 24/04/2023.
//  
//

import SwiftUI

struct ArticleDetailsView: View {
    let article: Article

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
        }
    }
}

struct ArticleDetailsView_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArticleDetailsView(article:
                                Article(id: "https://t3n.de/news/infografik-energieverbrauch-bitcoin-ethereum-vergleich-1548941/",
                                     source: .init(id: "t3n", name: "T3n"),
                                     author: "Kay Nordenbrock",
                                     title: "Energieverbrauch von Bitcoin und Ethereum: Wie Wolkenkratzer neben Himbeere",
                                     description: "Bitcoin verbraucht deutlich mehr Energie als Ethereum. Ethereum mit Proof-of-Stake wiederum benötigt deutlich",
                                     url: URL(string: "https://t3n.de/news/infografik-energieverbrauch-bitcoin-ethereum-vergleich-1548941/")!,
                                     urlToImage: URL(string: "https://t3n.de/news/wp-content/uploads/2023/04/Bitcoin-Ethereum-stromverbrauch-vergleich.jpg")!,
                                     publishedAt: Date(timeIntervalSince1970: 1682773200),
                                     content: "Die University of Cambridge zeigt in einer Analyse, wie viel Energie Ethereum vor und nach dem Wechsel von Proof-of-Work zu Proof-of-Stake verbraucht und wie diese Werte mit dem Verbrauch von Bitcoin… [+2366 chars]")
            )
            .navigationBarItems(leading: Button(action: {}, label: { Image(systemName: "chevron.left") }))
        }
        .navigationViewStyle(.stack)
        .preferredColorScheme(.dark)
    }
}
