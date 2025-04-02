//
//  UpDownView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import SwiftUI

struct UpDownView: View {
    
    @Binding var didTapUp: Bool
    @Binding var didTapDown: Bool
    
    var body: some View {
        VStack {
            SquareButton(action: $didTapUp, icon: .arrowUp)
            SquareButton(action: $didTapDown, color: Theme.shared.blue)
        }
    }
}

#Preview {
    UpDownView(didTapUp: .constant(false), didTapDown: .constant(false))
}
