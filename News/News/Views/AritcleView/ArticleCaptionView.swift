//
//  Created on 24/04/2023.
//  
//

import SwiftUI

struct ArticleCaptionView: View {
    let source: String
    let publishedDate: Date

    var body: some View {
        HStack(spacing: 10) {
            Text(source)
                .foregroundColor(.secondaryAccentColor)
                .accessibilityIdentifier("source")

            Text(publishedDate, style: .relative)
                .foregroundColor(.secondaryText)
                .accessibilityIdentifier("creationDate")

            Spacer()
        }
        .font(.caption)
        .padding(.zero)
        .foregroundColor(.primaryText)
        .frame(maxWidth: .infinity)
    }
}

struct ArticleCaptionView_Preview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ArticleCaptionView(source: "CNN", publishedDate: Date(timeIntervalSinceNow: -3000))
        }
        .preferredColorScheme(.dark)
    }
}
