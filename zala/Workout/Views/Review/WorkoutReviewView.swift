//
//  WorkoutReviewView.swift
//  zala
//
//  Created by Kyle Carriedo on 3/25/24.
//

import SwiftUI
import ZalaAPI
import MarkdownUI

enum WorkoutKind {
    case time, rpe, distance, none, weight
}

enum WorkoutReviewType {
    case none, viewOnly, start
}

struct WorkoutReviewView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showInstructions: Bool = true
    @State private var expandAll: Bool = true
    @State private var workoutSetModel: WorkoutSetModel?
    
    @State var workoutPlan: WorkoutPlanModel
    @State var workoutPlanSelection: WorkoutPlanSelection? = nil
    @State var workoutManager: WorkoutManager? = nil
    
    @State var viewType: WorkoutReviewType = .none
    var onComplete: ((_ planId: String) -> Void)?
    
    var body: some View {
        VStack {
            ScrollView {
                ExpandedHeaderView(title: "Instructions", expand: $showInstructions)
                if showInstructions, let desc = workoutPlan.desc {
                    VStack {
                        HTMLText(htmlContent: desc).renderText()
                            .align(.leading)
                        Image.demoWorkout
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                buildPreviewExpandedView()
                ForEach(workoutPlan.allGroups, id:\.id) { group  in
                    WorkoutSetView(exerciseGroup: group, expandedAll: $expandAll)
                }
            }
            Spacer()
            if viewType == .start {
                Divider().background(.gray)
                StandardButton(title: "Start") {
                    workoutSetModel = workoutPlanSelection?.set
                }.padding()
            }
        }
        .navigationDestination(item: $workoutSetModel, destination: { set in
            WorkoutExerciseView(exercise: set, onComplete: { planId in
                onComplete?(planId)
            })
            .environment(workoutManager)

        })
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("ZALA WORKOUT")
                        .style(color: .white, size: .x18)
                    Text(workoutPlan.title?.capitalized ?? "Exercise")
                        .style(color: Theme.shared.grayStroke, size: .small)
                }
            }
            if viewType == .start {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image.xIcon
                    }

                }
            }
        })
    }
    
    @ViewBuilder
    fileprivate func buildPreviewExpandedView() -> some View {
        HStack {
            Text("Workout Preview")
                .style(color: .white, size: .x18, weight: .w700)
            Spacer()
            Button {
                withAnimation {
                    expandAll.toggle()
                }
            } label: {
                Text(expandAll ? "Collapse All" : "Expand All")
                    .style(color: expandAll ? Theme.shared.orange : Theme.shared.blue)
            }
        }
    }
}

import SwiftUI

struct HTMLText {
    let htmlContent: String

    func renderText() -> Text {
        // Convert the HTML string to an attributed string        
        guard let data = htmlContent.data(using: .utf8),
              let attributedString = try? NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil
              ) else {
            return Text(htmlContent) // Fallback to plain text
        }
        
        // Parse and build SwiftUI Text
        return parseAttributedString(attributedString)
    }

    private func parseAttributedString(_ attributedString: NSAttributedString) -> Text {
        var text = Text("")
        attributedString.enumerateAttributes(
            in: NSRange(location: 0, length: attributedString.length),
            options: []
        ) { attributes, range, _ in
            let substring = attributedString.attributedSubstring(from: range).string
            var currentText = Text(substring)
            
            // Apply styles from attributes
            if let font = attributes[.font] as? UIFont {
                if font.fontDescriptor.symbolicTraits.contains(.traitBold) {
                    currentText = currentText.bold()
                }
                if font.fontDescriptor.symbolicTraits.contains(.traitItalic) {
                    currentText = currentText.italic()
                }
            }
            
            if let underline = attributes[.underlineStyle] as? NSNumber, underline != 0 {
                currentText = currentText.underline()
            }
            
            // Concatenate with previous parts
            text = text + currentText
        }
        
        return text
    }
}
//
//struct HTMLText: View {
//    let htmlContent: String
//    
//    var body: some View {
//        renderText()
//    }
//    
//    private func renderText() -> Text {
//        // Convert the HTML string to an attributed string
//        guard let data = htmlContent.data(using: .utf8),
//              let attributedString = try? NSAttributedString(
//                data: data,
//                options: [.documentType: NSAttributedString.DocumentType.html,
//                          .characterEncoding: String.Encoding.utf8.rawValue],
//                documentAttributes: nil
//              ) else {
//            return Text(htmlContent) // Fallback to plain text
//        }
//        
//        // Parse and build SwiftUI Text
//        return parseAttributedString(attributedString)
//    }
//    
//    private func parseAttributedString(_ attributedString: NSAttributedString) -> Text {
//        var text = Text("")
//        attributedString.enumerateAttributes(
//            in: NSRange(location: 0, length: attributedString.length),
//            options: []
//        ) { attributes, range, _ in
//            let substring = attributedString.attributedSubstring(from: range).string
//            var currentText = Text(substring)
//            
//            // Apply styles from attributes
//            if let font = attributes[.font] as? UIFont {
//                if font.fontDescriptor.symbolicTraits.contains(.traitBold) {
//                    currentText = currentText.bold()
//                }
//                if font.fontDescriptor.symbolicTraits.contains(.traitItalic) {
//                    currentText = currentText.italic()
//                }
//            }
//            
//            if let underline = attributes[.underlineStyle] as? NSNumber, underline != 0 {
//                currentText = currentText.underline()
//            }
//            
//            // Concatenate with previous parts
//            text = text + currentText
//        }
//        
//        return text
//    }
//}
