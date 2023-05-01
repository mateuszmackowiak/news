//
//  Created on 24/04/2023.
//  
//

import SwiftUI

struct ArticleBasicInfoView: View {
    let title: String
    let source: ArticleSource

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .lineLimit(3)
                    .accessibilityIdentifier("title")
            }
            ArticleSourceView(source: source)
        }
        .multilineTextAlignment(.leading)
        .padding()
        .foregroundColor(.primaryText)
        .frame(maxWidth: .infinity)
    }
}

struct ArticleBasicInfoView_Preview: PreviewProvider {
    static var previews: some View {
        List {
            Group {
                ArticleBasicInfoView(title: "Kryształy nie są żywe, a wciąż zawstydzają nas swoją \"inteligencją\". Tak mało o nich wiemy - CHIP", source: ArticleSource(id: "google-news", name: "Google Article"))
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowBackground(Color.clear)
        }

        .preferredColorScheme(.dark)
    }
}
