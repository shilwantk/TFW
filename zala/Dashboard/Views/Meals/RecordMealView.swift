//
//  RecordMealView.swift
//  zala
//
//  Created by Kyle Carriedo on 9/14/24.
//

import SwiftUI
import ZalaAPI

struct RecordMealView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var time: Date = .now
    @State var note: String = ""
    @State var cameraSelected: Bool = false
    @State var sendTapped: Bool = false
    @State var selectedImage: UIImage = UIImage()
    @State var service: TasksService = TasksService()
    @State var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }
            VStack(alignment: .leading, spacing: 25) {
                ZStack(alignment:.top) {
                    if isLoading {
                        LoadingBannerView(message: "Saving...")
                            .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                    }
                }
                ScrollView {
                    Text("Select meal date and time")
                        .style(size:.x20, weight: .w400)
                        .align(.leading)
                    DateDropDownView(
                        key: "Date & Time",
                        selectedDate: $time,
                        dateAndTime: .constant(true),
                        isDob: false,
                        showKey: true,
                        darkMode: true)
                    VStack(alignment: .leading, spacing: 25) {
                        Text("Want to take a photo of your meal?")
                            .style(size:.x20, weight: .w400)
                            .align(.leading)
                        if selectedImage.size.height > 0 {
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .interpolation(.medium)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity, maxHeight: 350, alignment: .center)
                                Button {
                                    selectedImage = UIImage()
                                } label: {
                                    Image.close
                                }
                            }
                        } else {
                            BorderedButton(title: "Add Photo", titleColor: Theme.shared.blue, color: Theme.shared.blue) {
                                cameraSelected.toggle()
                            }
                        }
                    }.padding(.top)
                    VStack(alignment: .leading) {
                        Text("Is there any additional information you would like to add?")
                            .style(size: .x18, weight: .w400)
                            .align(.leading)
                        VStack(alignment: .leading, spacing: 0.0) {
                            TextEditor(text: $note)
                                .scrollContentBackground(.hidden)
                                .background(Theme.shared.mediumBlack)
                                .frame(maxHeight: 350)
                        }
                        .frame(minHeight: 350)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).fill(Theme.shared.mediumBlack))
                    }.padding(.top)
                }
                Spacer()
                StandardButton(title: "SUBMIT") {
                    save()
                }
            }
        }
        .padding()
        .navigationTitle("RECORD MEAL")
        .navigationBarTitleDisplayMode(.inline)
        .imageSelection(image: $selectedImage, showPhoto: $cameraSelected)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image.xIcon
                })
            }
        }
        .onChange(of: service.taskSaved) {
            dismiss()
        }
    }
    
    fileprivate func save() {
        withAnimation {
            isLoading.toggle()
        }
        
        let dataValue = "1"
        
        guard let identifier = Network.shared.userId() else { return }
        let key = "person.meal"
        
        let unit = "count"
        
        let title = "Meal Recorded"
        
//        let dates = times()
        let beganEpoch = Int(time.timeIntervalSince1970)
        let endEpoch = Int(time.timeIntervalSince1970 + 100)
        
        var json:[String: Any] = [ "value": dataValue]
        
        var input = AnswerInput(key: key,
                    unit: .some(unit),
                    beginEpoch: .some(beganEpoch),
                    endEpoch: .some(endEpoch),
                    source: .some(DataValueSourceInput(name: .some("manual entry"),
                                                       identifier: .some(identifier))))
        
        if !note.isEmpty {
            input.note = .some(.init(body: .some(note), author: .some(identifier)))
        }
        
        if selectedImage.size.height > 0,
           let base64 = selectedImage.base64(compressionQuality: .half){
            service.upload(base64: base64, attachmentKey: .meal) { attachmentId in
                if let attachmentId {
                    json["attachmentIds"] = [attachmentId]
                    input.datum = .some(json.toJSONString() ?? "")
                    service.postTaskResults(title: title.lowercased(), taskInput: input)
                }
            }
        } else {
            input.datum = .some(json.toJSONString() ?? "")
            service.postTaskResults(title: title.lowercased(), taskInput: input)
        }
    }
}

#Preview {
    RecordMealView()
}
