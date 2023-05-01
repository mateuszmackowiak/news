//
//  ActivityIndicatorView.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import SwiftUI

struct ActivityIndicatorView: View {
    private struct DotView: View {
        @State var delay: Double
        @State private var scale: CGFloat = 0.2
        var body: some View {
            Circle()
                .scaleEffect(scale)
                .animation(Animation.easeInOut(duration: 0.4).repeatForever().delay(delay), value: UUID())
                .foregroundColor(.accentColor)
                .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 5)
                .onAppear {
                    withAnimation {
                        self.scale = 1
                    }
                }
        }
    }

    var body: some View {
        HStack {
            DotView(delay: 0)
            DotView(delay: 0.4)
            DotView(delay: 0.8)
        }
    }
}

struct ActivityIndicatorView_Preview: PreviewProvider {
    static var previews: some View {
        ActivityIndicatorView().frame(width: 48)
    }
}
