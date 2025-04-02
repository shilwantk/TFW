//
//  SquareButton.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import SwiftUI

struct SquareButton: View {
    @Binding var action: Bool
    @State var icon: Image = Image.downArrow
    @State var borderOnly: Bool = false
    @State var color: Color = Theme.shared.upDownButton
    
    var body: some View {
        Button {
            action.toggle()
        } label: {
            icon
        }
        .frame(width: 44, height: 44)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Theme.shared.border, lineWidth: borderOnly ? 2.0 : 0.0)
                .fill(borderOnly ? .black : color )
        )
        
        
    }
}

#Preview {
    SquareButton(action: .constant(false))
}
