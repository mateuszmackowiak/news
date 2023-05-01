//
//  LogoView.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        Image.logo
            .resizable()
            .aspectRatio(contentMode: .fit)
            .accessibilityIdentifier("logo")
    }
}

