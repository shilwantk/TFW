//
//  ZalaEmptyView.swift
//  zala
//
//  Created by Kyle Carriedo on 5/17/24.
//

import SwiftUI

struct ZalaEmptyView: View {
    @State var icon: Image = .logoLrg
    @State var title: String
    @State var msg: String =  "Your Superuser has something in the works."
    var body: some View {
        VStack {
            Spacer()
            icon
            Text(title)
                .style(size:.x28, weight: .w800).padding(.bottom)            
            Text(msg)
                .style(weight: .w400)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
    }
}
