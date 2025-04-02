//
//  BaselineSliderQuestionView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/28/24.
//

import SwiftUI

struct BaselineSlider: Hashable {
    var id = UUID()
    var title:String
    var value:Double
}

struct BaselineSliderView: View {
    @State var question: BaselineSlider
    var body: some View {
        VStack(spacing: 10) {
            Text(question.title)
                .style(weight: .w400)
                .frame(maxWidth:.infinity,  alignment: .leading)
            Slider(value: $question.value, in: 0...10, step: 1).tint(Theme.shared.blue)
            HStack(alignment: .center, content: {
                ForEach(0...10, id:\.self) { value in
                    Text("\(value)")
                        .style(size: .xSmall, weight:.w400)
                    if value != 10 {
                        Spacer()
                    }
                }
            })
            .padding(.leading)
        }
    }
}
struct BaselineSliderQuestionView: View {
    @State var baselineQuestion: BaselineQuestion
    @State var current: Double
    @State var total: Double

    @Binding var didTapNext: Bool
    @Binding var didTapBack: Bool
        
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
                    .frame(maxWidth: .infinity, alignment:.leading)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(5)
                ForEach(Array(baselineQuestion.sliderOptions.enumerated()), id:\.offset) { idx, question in
                    BaselineSliderView(question: question).padding([.bottom, .top], 15)
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
            .padding()
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
