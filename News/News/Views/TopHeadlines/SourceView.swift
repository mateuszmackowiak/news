//
//  Created on 24/04/2023.
//  
//

import SwiftUI

struct ArticleSourceView: View {
    let source: ArticleSource

    var body: some View {
        HStack(spacing: 10) {
            Text(source.name)
                .foregroundColor(.accentColor)
                .accessibilityIdentifier("source")
            Spacer()
        }
        .font(.caption)
        .padding(.zero)
        .foregroundColor(.primaryText)
        .frame(maxWidth: .infinity)
    }
}

struct SourceView_Preview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ArticleSourceView(source: .init(id: "cnn", name: "CNN"))
        }
        .preferredColorScheme(.dark)
    }
}
