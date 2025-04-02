//
//  BaselineQuestionView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/20/24.
//

import SwiftUI
import ZalaAPI

extension AnswerInput: @retroactive Identifiable {
    public var id: String {
        return key
    }
}

struct BaselineCheckboxQuestionView: View {
    
    @State var baselineQuestion: ZalaQuestion
    @State var isMuti: Bool = true
    @State var current: Double
    @State var total: Double
    
    @State var selections: Set<String> = [] //selected keys
    @State var answers: Set<String> = [] //selected answers
    @State var answerInput: AnswerInput? = nil
    
    //other case
    @State var freeText: String = ""
    
    @Binding var didTapNext: Bool
    @Binding var didTapBack: Bool
    @Binding var didDismiss: Bool
    
    @Environment(SurveyService.self) private var service
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(baselineQuestion.text)
                .style(color: .white, size: .x18, weight: .w400)
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .lineSpacing(5)
                .padding([.leading, .trailing], 13)
            ScrollView {
                ForEach(baselineQuestion.sortedKeys(), id:\.self) { key in
                    let choice = baselineQuestion.choices[key] ?? ""
                    if let data = choice.titleAndSubtitle() {
                        self.item(key: key, title: data.title, subtitle: data.subtitle, choice: choice).padding(4)
                    } else {
                        self.item(key:  key, title: choice, subtitle: nil, choice: choice).padding(4)
                    }
                }
            }
            Spacer()
            StandardButton(title: "CONTINUE") {
                guard !selections.isEmpty else { return }
                insertAnswer()
                if answerInput != nil {
                    didTapNext.toggle()
                }
            }.padding()
        }
        .padding([.leading, .trailing, .top])
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    didTapBack.toggle()
                } label: {
                    Image.leftArrow
                }
            }
            ToolbarItem(placement: .principal) {
                SurveyCounterView(current: current, total: total)
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    service.reset()
                    didDismiss.toggle()
                } label: {
                    Image.close
                }
            }
        })
    }
    
    fileprivate func clearIfNeeded(key: String) {
        if key.lowercased() == "none" {
            selections.removeAll()
            answers.removeAll()
        } else if key.lowercased().contains("other") {
            selections.removeAll()
            answers.removeAll()
        } else {
            selections.remove("none")
            answers.remove("none")
            if let other = selections.first(where: {$0.contains("other")}) {
                selections.remove(other)
            }
            if let otherAnswer = answers.first(where: {$0.contains("other")}) {
                answers.remove(otherAnswer)
            }
        }
    }

    
    private func item(key: String,  title: String, subtitle: String?, choice: String) -> some View {
        VStack {
            SelectionCellView(label: title,
                              subTitle: subtitle,
                              isSelected: .constant(selections.contains(key)))            
            .contentShape(Rectangle())
            .onTapGesture {
                clearIfNeeded(key: key)
                if isMuti {
                    if selections.contains(key) {
                        selections.remove(key)
                        answers.remove(choice)
                    } else {
                        selections.insert(key)
                        answers.insert(choice)
                    }
                } else {
                    answers = []
                    selections = []
                    selections.insert(key)
                    answers.insert(choice)
                }
            }
            if selections.contains(key) && key.contains("other") {
                VStack(alignment: .leading, spacing: 0.0) {
                    TextEditor(text: $freeText)
                        .scrollContentBackground(.hidden)
                        .background(Theme.shared.mediumBlack)
                        .frame(maxHeight: 200)
                }
                .frame(minHeight: 200)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack))
            }
        }
    }
    
    fileprivate func insertAnswer() {
        if freeText.isEmpty {
            answerInput = .init(key: baselineQuestion.key, data: .some(Array(selections)))
        } else {
            answerInput = .init(key: baselineQuestion.key, data: .some([freeText]))
        }
        service.insert(answerInput)
    }
}

struct SurveyCounterView: View {
    let current: Double
    let total: Double
    var body: some View {
        VStack {
            Text("Zala Baseline")
                .style(color: .white, size:.x18, weight:.w800)
            HStack {
                Text("\(Int(current) + 1)")
                    .style(color: .white, size:.x13, weight:.w800)
                Text("of")
                    .style(color: .white, size:.x13, weight:.w800)
                Text("\(Int(total))")
                    .style(color: .white, size:.x13, weight:.w800)
            }
        }
    }
}

struct BaselineQuestionView: View {
    
    @State var baselineQuestion: ZalaQuestion
    @State var isMuti: Bool = true
    @State var current: Double
    @State var total: Double
    
    @State var selections: Set<String> = [] //selected keys
    @State var answers: Set<String> = [] //selected answers
    @State var answerInput: AnswerInput? = nil
    
    //other case
    @State var freeText: String = ""
    
    @Binding var didTapNext: Bool
    @Binding var didTapBack: Bool
    @Binding var didDismiss: Bool
    
    @Environment(SurveyService.self) private var service
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(spacing: 5) {
                Text(baselineQuestion.text)
                    .style(color: .white, size: .x18, weight: .w400)
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(5)
                    .padding([.leading, .trailing], 13)
                if baselineQuestion.isMulti() {
                    Text("Choose all that Apply.")
                        .style(color: .white, size: .x13, weight: .w400)
                        .lineLimit(1)
                        .align(.leading)
                        .padding([.leading, .trailing], 13)
                        .padding(.bottom)
                }
            }
            AnswerGridView(keys: Array(baselineQuestion.choices.keys), 
                           baselineQuestion: baselineQuestion,
                           selections: $selections,
                           answers: $answers)
            Spacer()
            StandardButton(title: "CONTINUE") {
                insertAnswer()
                didTapNext.toggle()
            }.padding()
        }
        .padding([.leading, .trailing, .top])
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(content: {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    didTapBack.toggle()
                } label: {
                    Image.leftArrow
                }
            }
            ToolbarItem(placement: .principal) {
                SurveyCounterView(current: current, total: total)
            }
            ToolbarItem(placement: .primaryAction) {
                Button {
                    service.reset()
                    didDismiss.toggle()
                } label: {
                    Image.close
                }
            }
        })
    }
    
    fileprivate func clearIfNeeded(key: String) {
        if key.lowercased() == "none" {
            selections.removeAll()
            answers.removeAll()
        } else {
            selections.remove("none")
            answers.remove("none")
        }
    }

    
    fileprivate func insertAnswer() {
        if freeText.isEmpty {
            answerInput = .init(key: baselineQuestion.key, data: .some(Array(answers)))
        } else {
            answerInput = .init(key: baselineQuestion.key, data: .some([freeText]))
        }
        service.insert(answerInput)
    }
}



struct AnswerGridView: View {
    @State var keys: [String]
    @State var baselineQuestion: ZalaQuestion
    @Binding var selections: Set<String>
    @Binding var answers: Set<String>
    @State var isMuti: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                FlowLayout(unspecified:.init(width: geometry.size.width, height: .infinity)) {
                    ForEach(keys, id:\.self) { key in
                        self.item(for: key).padding(4)
                    }
                }
            }
        }
    }
    
    private func item(for key: String) -> some View {
        Text(baselineQuestion.choices[key] ?? "")
            .style(color: selections.contains(key) ? .black : Theme.shared.grayStroke, size: .x16, weight: .w500)
            .padding([.leading, .trailing], 15)
            .padding([.top, .bottom], 12)
            .background(
                Capsule()
                    .stroke(selections.contains(key) ? Theme.shared.lightBlue : Theme.shared.placeholderGray, lineWidth: 1)
                    .fill(selections.contains(key) ? Theme.shared.lightBlue : .black)
            )
            .onTapGesture {
                clearIfNeeded(key: key)
                let choice = baselineQuestion.choices[key] ?? ""
                if isMuti {
                    if selections.contains(key) {
                        selections.remove(key)
                        answers.remove(choice)
                    } else {
                        selections.insert(key)
                        answers.insert(choice)
                    }
                } else {
                    answers = []
                    selections = []
                    selections.insert(key)
                    answers.insert(choice)
                }
            }
    }
    
    fileprivate func clearIfNeeded(key: String) {
        if key.lowercased() == "none" {
            selections.removeAll()
            answers.removeAll()
        } else {
            selections.remove("none")
            answers.remove("none")
        }
    }
}
