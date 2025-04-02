//
//  ExpandedHeaderView.swift
//  zala
//
//  Created by Kyle Carriedo on 9/21/24.
//

import SwiftUI

struct ExpandedHeaderView: View {
    
    @State var title: String
    @Binding var expand: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .style(color: .white, size: .x18, weight: .w700)
            Spacer()
            Image.arrowUp
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 27)
                .rotationEffect(.degrees(expand ? 0 : 180))
        }
        .contentShape(RoundedRectangle(cornerRadius: 0))
        .onTapGesture {
            withAnimation {
                expand.toggle()
            }
        }
    }
}

#Preview {
    ExpandedHeaderView(title: "", expand: .constant(false))
}
