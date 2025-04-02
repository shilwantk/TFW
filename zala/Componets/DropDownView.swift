//
//  DropDownView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import SwiftUI

let defaultPickerItem =  PickerItem(title: "", key: "-99")

struct DropDownView: View {
    
    @State var key: String = ""
    @Binding var selectedOption: PickerItem
    @State private var showCover: Bool = false
    @Binding var items: [PickerItem]
    @State var isRequired: Bool = false
    @State var height: CGFloat = 55
    @State var darkMode: Bool = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeOut) {
                    showCover.toggle()
                }
            } label: {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .center) {
                        Text(showText() ? selectedOption.title : "Select \(key)")
                            .style(color: showText() ? .white : .white,
                                   size: .regular,
                                   weight: .w700)
                            .padding(.leading)
                        Spacer()
                        Image("down-arrow")
                            .rotationEffect(.radians(showCover ? .pi : 0))
                            .padding(.trailing)
                    }
                    .frame(height: height)
                    .background(
                      LinearGradient(
                        stops: [
                            Gradient.Stop(color: darkMode ? Theme.shared.medGray : Theme.shared.grayGradientColor.primary, location: 0.00),
                            Gradient.Stop(color: darkMode ? Theme.shared.medGray : Theme.shared.grayGradientColor.secondary, location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                      )
                    )
                    .cornerRadius(10)
                }
            }
            .animation(.linear, value: showText())
            if showCover {
                PickerSheet(selection:$selectedOption, items: items)
                    .frame(minHeight: 200)
            }
        }
    }
    
    func showText() -> Bool {
        return self.selectedOption.key != "-99"
    }
}

struct DropDownView_Previews: PreviewProvider {
    static var previews: some View {
        DropDownView(selectedOption: .constant(defaultPickerItem), items: .constant([]))
    }
}
