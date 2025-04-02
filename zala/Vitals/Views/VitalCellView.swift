//
//  VitalCellView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI

struct VitalCellView: View {
    @State var key: String = "Blood Oxygen"
    @State var value: String?
    @State var unit: String?
    @State var datetime: String?
    @State var elevated: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(key)
                    .style(color:Theme.shared.placeholderGray, weight: .w400)
                Spacer()
                if let datetime {
                    Text(datetime)
                        .style(color:Theme.shared.placeholderGray, weight: .w400)
//                    Image.arrowRight

                }
            }
            if let value, let unit  {
                HStack(alignment: .bottom) {
                    Text(value)
                        .style(color: elevated ? Theme.shared.purple : .white,
                               size:.x22, weight: .w700)
                    Text(unit)
                        .style(color: Theme.shared.placeholderGray,
                               size:.small, weight: .w400)
                }
            } else {
                Text("No value found")
                    .italic()
                    .style(color: .white, size:.small, weight: .w400)
            }
        }
    }
}

#Preview {
    VitalCellView()
}
