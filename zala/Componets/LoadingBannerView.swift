//
//  LoadingBannerView.swift
//  zala
//
//  Created by Kyle Carriedo on 11/29/24.
//

import SwiftUI

struct LoadingBannerView: View {
    
    let message: String
    
    init(message: String = "Loading...") {
        self.message = message
    }
    
    var body: some View {
        HStack(spacing: 10) {
            Spacer()
            ProgressView().progressViewStyle(.circular)
            Text(message)
                .style(size:.x16, weight: .w500)
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack))
    }
}

#Preview {
    LoadingBannerView()
}
