//
//  SegmentedControlView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/22/24.
//

import SwiftUI

enum SegmentedItemType {
    case profile
    case content
    case routine
    case appointment
    case events
    case store
    case none
}

struct SegmentedValue: Equatable {
    var title: String
    var key: String
    
    static let `default` = SegmentedValue(title: "item", key: "item")
}

struct SegmentedItem: Equatable, Hashable {
    var title: String
    var key: SegmentedItemType = .none
    
    static let `default` = SegmentedItem(title: "Profile", key: .profile)
    
    static let `none` = SegmentedItem(title: "none", key: .none)
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}

struct SegmentedControlButtonView: View {
    
    @State var items: [SegmentedValue]
    @Binding var selection: SegmentedValue
    
    var body: some View {
        HStack {
            ForEach(items, id: \.key) { item in
                Button {
                    selection = item
                } label: {
                    Text(item.title)
                        .style(color: .white,
                               size: .regular,
                               weight: .w700)
                        .frame(maxWidth:.infinity)
                        .padding([.leading, .trailing], 10)
                        .padding([.top, .bottom], 8)
                }
                .selectionBackground(selected: .constant(selection == item))
                if item.key != items.last?.key {
                    Spacer()
                }
            }
        }
        .background(RoundedRectangle(cornerRadius: 8).fill(Theme.shared.baseSlate))
    }
}

struct SegmentedControlView: View {
    
    @State var items: [SegmentedItem]
    @Binding var selection: SegmentedItem
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(alignment: .center) {
                ForEach(items, id: \.key) { item in
                    Button(action: {
                        selection = item
                    }, label: {
                        Text(item.title)
                            .style(color: .white,
                                   size: .regular,
                                   weight: .w700)
                            .padding([.leading, .trailing], 10)
                            .padding([.top, .bottom], 8)
                    })
                    .selectionBackground(selected: .constant(selection == item))
                }
            }
            .background(RoundedRectangle(cornerRadius: 8).fill(Theme.shared.baseSlate))
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    SegmentedControlView(items: [
        SegmentedItem(title:"Profile", key: .profile),
        SegmentedItem(title:"Content", key: .content),
        SegmentedItem(title:"Routines", key: .routine),
        SegmentedItem(title:"Appointments", key: .appointment),
        SegmentedItem(title:"Events", key: .events),
        SegmentedItem(title:"Store", key: .store)],
                         selection: .constant(SegmentedItem(title:"Profile",key: .profile)))
}
