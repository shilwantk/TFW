//
//  BaselineDropDownQuestion.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import SwiftUI

let yesNo:[PickerItem] = [PickerItem(title: "Yes", key: "yes"),
                          PickerItem(title: "No", key: "no"),
                          PickerItem(title: "N/A", key: "n/a")]

struct BaselineDropDownQuestion: View {
    
    @State var baselineQuestion: BaselineQuestion
    @State var isMuti: Bool = true
    @State var current: Double
    @State var total: Double
    @Binding var didTapNext: Bool
    @Binding var didTapBack: Bool
    
    @State var selectedItem: PickerItem = PickerItem(title: "Select", key: "empty")
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ProgressView(value: current, total: total)
                    .tint(Theme.shared.blue)
                    .padding([.leading, .trailing], 80)
                    .padding(.bottom, 22)
                Text(baselineQuestion.question)
                    .style(color: .white, size: .x18, weight: .w400)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(5)
                    .padding(.leading)
                VStack {
                    DropDownView(selectedOption: $selectedItem, items: $baselineQuestion.dropdownOptions)
                        .padding(.bottom, 24)
                    Rectangle()
                        .fill(Theme.shared.gray)
                        .frame(height: 1)
                        .edgesIgnoringSafeArea(.horizontal)
                        .padding(.bottom, 24)
                    HStack(alignment: .center, content: {
                        Spacer()
                        UpDownView(didTapUp: $didTapNext,
                                   didTapDown: $didTapBack)
                    })
                }
                .padding([.leading, .trailing, .top])
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    SurveyCounterView(current: current, total: total)
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        
                    } label: {
                        Image.close
                    }
                }
            })
        }
    }
}
