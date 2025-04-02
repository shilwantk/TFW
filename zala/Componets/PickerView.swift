//
//  PickerView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import SwiftUI

struct PickerItem:Codable, Hashable, Equatable {
    var title:String
    var key:String
    var color:String? = nil
    
    static let defaultPart = PickerItem(title: "Part A", key: "part_a")
    static let defaultEnrolledStatus = PickerItem(title: "Not Enrolled", key: "not_enrolled")
    static let defaultDropdown = PickerItem(title: "Choose Option", key: "empty")
    
}


struct PickerSheet: View {
    @State   var title:         String    = ""
    @Binding var selection:     PickerItem
    @State   var items:        [PickerItem]   = []
    @State   var showSelect:    Bool      = false
    @State   var buttonTitle:   String    = ""
    
    var actionTapped: (() -> Void)?
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
            Text(title)
            Picker(selection: $selection, label: Text("Query Type")) {
                ForEach(items, id: \.self) { item in
                    Text(item.title).style(color:color(item: item), size: .large)
                }
            }.pickerStyle(WheelPickerStyle())
            if showSelect {
                StandardButton(title: buttonTitle) {
                    actionTapped?()
                    presentation.wrappedValue.dismiss()
                }.padding([.leading, .trailing])
            }
        }
    }
    
    fileprivate func color(item:PickerItem) -> Color {
        if let clr = item.color, !clr.isEmpty {
            return Color(hex: clr)
        } else {
            return .white
        }
    }
}

struct PickerSheet_Previews: PreviewProvider {
    static var previews: some View {
        PickerSheet(selection: .constant(PickerItem(title: "", key: "")))
    }
}
