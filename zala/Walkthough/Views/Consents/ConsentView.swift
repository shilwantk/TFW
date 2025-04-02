//
//  ConsentView.swift
//  zala
//
//  Created by Kyle Carriedo on 9/17/24.
//

import SwiftUI
import MarkdownUI

struct ConsentData: Identifiable {
    var id = UUID()
    var data: Data
}

struct ConsentView: View {
//    @Environment(\.dismiss) var dismiss
    @Binding var didSign: Bool
    @Environment(SurveyService.self) private var service
    @State private var taskService = TasksService()
    
    @State private var didAgree: Bool = false
    @State private var showSig: Bool = false
    @State private var isLoading: Bool = false
    @State private var image: UIImage? = nil
    @State private var allImages: [SignatureImageModel] = []
    @State private var pdfData: ConsentData? = nil
    
    var body: some View {
        VStack {
            ZStack(alignment:.top) {
                if isLoading {
                    LoadingBannerView(message: "Saving...")
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                }
            }
            ScrollView {
                Markdown(service.zalaConsent?.docMarkdown ?? "")
                SelectionCellView(label: "I agree to Zala’s terms & conditions", isSelected: $didAgree).onTapGesture {
                    didAgree.toggle()
                }
                VStack {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .onTapGesture {
                                showSig.toggle()
                            }
                    } else {
                        Button {
                            showSig.toggle()
                        } label: {
                            Text("Sign")
                        }
                        .contentShape(RoundedRectangle(cornerRadius: 16))
                        .frame(maxWidth: .infinity, minHeight: 95.0)
                    }
                }
                .background(Theme.shared.mediumBlack)
                .contentShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: .infinity, minHeight: 95.0)
            }
            Spacer()
             StandardButton(title: "CONTINUE") {
                 if isComplete(), let image {
                     updateLoading()
                     let renderImage = allImages.first{$0.type == .small}?.image ?? image
                     let pfg = PDFCreator()
                     let consent = ConsentTemplateModel(title: "Zala’s Terms & Conditions",
                                                        content: service.zalaConsent?.docMarkdown,
                                                        sections: [
                                                            ConsentSection(fields: [
                                                                .init(content: "I agree to Zala’s terms & conditions",
                                                                      value: "I agree to Zala’s terms & conditions",
                                                                      type: .checkboxwithvalue,
                                                                      dateValue: .now,
                                                                      selectionValue: true,
                                                                      autoDate: "-"),
                                                                .init(value: "",
                                                                      type: .signature,
                                                                      dateValue: .now,
                                                                      selectionValue: false,
                                                                      sigImage: renderImage,
                                                                      autoDate: "")
                        ])
                     ])
                     guard let data = pfg.createPDF(attributedString: pfg.pdfAttributed(consent: consent, images: []), images: []) else { return }
                     saveConsent(data: data)
                 }
            }
        }
        .padding()
        .onChange(of: taskService.taskSaved, { oldValue, newValue in
            service.didSignConsent()
        })
        .onChange(of: service.complete, { oldValue, newValue in
            updateLoading()
            didSign.toggle()
        })
        .task {
            service.fetchData()
        }
        .sheet(item: $pdfData, content: { consent in
            NavigationStack {
                PDFViewRepresentable(data: consent.data)
                                   .edgesIgnoringSafeArea(.all)
            }
        })
        .fullScreenCover(isPresented: $showSig) {
            SignatureView(availableTabs: [.type, .draw]) { img, allImages in
                self.allImages = allImages
                self.image = allImages.first(where: {$0.type == .large})?.image ?? img
                showSig.toggle()
            } onCancel: {
                showSig.toggle()
            }
        }
    }
    
    fileprivate func saveConsent(data: Data) {
        let base64 = "data:image/jpeg;base64,\(data.base64EncodedString())"
//                     self.pdfData = ConsentData(data: data)
        taskService.upload(base64: base64,
                           attachmentKey: .consent) { attachmentId in
            if let attachmentId {
                let json: [String: Any] = ["attachmentId": attachmentId]
                self.taskService.postTaskResults(title: "Zala’s Terms & Conditions",
                                            taskInput: .init(key: .consent,
                                                             datum: .some(json.toJSONString() ?? "")))
            }
        }
    }
    
    fileprivate func isComplete() -> Bool {
        return image != nil  &&  didAgree
    }
    
    fileprivate func updateLoading() {
        withAnimation {
            isLoading.toggle()
        }
    }
}
