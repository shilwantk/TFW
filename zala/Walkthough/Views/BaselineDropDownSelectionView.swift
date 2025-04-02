//
//  BaselineDropDownSelectionView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import SwiftUI

struct BaselineDropDownSelectionView: View {
    @State private var selectedItem: PickerItem = .defaultDropdown
    
    @State var baselineQuestion: BaselineQuestion
    @State var isMuti: Bool = true
    @State var current: Double
    @State var total: Double

    @State private var selection:String = ""
    @State private var selections: Set<String> = []
    
    @Binding var didTapNext: Bool
    @Binding var didTapBack: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                ProgressView(value: current, total: total)
                    .tint(Theme.shared.blue)
                    .padding([.leading, .trailing], 80)
                    .padding(.bottom, 22)
                Text(baselineQuestion.question)
                    .style(color: .white, size: .x18, weight: .w400)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(5)
                    .padding([.leading, .trailing], 13)
                VStack {
                    DropDownView(selectedOption: $selectedItem, items: $baselineQuestion.dropdownOptions)
                        .padding(.bottom, 24)
                    if selectedItem.key.lowercased() == baselineQuestion.dropDownRevealKey {
                        ForEach(baselineQuestion.selectionOptions, id: \.self) { question in
                            SelectionCellView(label: question, isSelected: .constant(selection == question)).onTapGesture {
                                selection = question
                            }
                        }
                    }
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
