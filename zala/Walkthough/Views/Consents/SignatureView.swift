//
//  SignatureView.swift
//  SwiftUI Recipes
//
//  Created by Gordan Glavaš on 28.06.2021..
//

import SwiftUI
import CoreGraphics
import UIKit

private let fontFamlies = ["Zapfino", "SavoyeLetPlain", "SnellRoundhand", "SnellRoundhand-Black"]
private let bigFontSize: CGFloat = 64
private let placeholderText = "Signature"
private let maxHeight: CGFloat = 160
private let lineWidth: CGFloat = 1

public enum SignatureImageType {
    case large, small
}

public struct SignatureImageModel {
    var type: SignatureImageType
    var image: UIImage
}

public struct SignatureView: View {
    public let availableTabs: [Tab]
    public let onSave: (_ viewImage: UIImage, _ allImages: [SignatureImageModel]) -> Void
    public let onCancel: () -> Void
    
    @State private var selectedTab: Tab
    
    @State private var saveSignature = false
    
    @State private var fontFamily = fontFamlies[2]
    @State private var color = Color.white
    
    @State private var drawing = DrawingPath()
    @State private var image = UIImage()
    @State private var isImageSet = false
    @State private var text = ""
    @State private var images: [SignatureImageModel] = []
    
    public init(availableTabs: [Tab] = Tab.allCases,
                onSave: @escaping (_ viewImage: UIImage, _ allImages: [SignatureImageModel]) -> Void,
                onCancel: @escaping () -> Void) {
        self.availableTabs = availableTabs
        self.onSave = onSave
        self.onCancel = onCancel
        
        self.selectedTab = availableTabs.first!
    }
    
    public var body: some View {
        VStack {
            HStack {
                Button("Done", action: extractImageAndHandle)
                    .foregroundColor(Theme.shared.blue)
                Spacer()
                Button("Cancel", action: onCancel)
                    .foregroundColor(Theme.shared.blue)
            }
            if availableTabs.count > 1 {
                Picker(selection: $selectedTab, label: EmptyView()) {
                    ForEach(availableTabs, id: \.self) { tab in
                        Text(tab.title)
                            .tag(tab)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            signatureContent
            Button("Clear signature", action: clear)
                .foregroundColor(Theme.shared.blue)
            //            HStack {
            //                if selectedTab == Tab.type {
            //                    FontFamilyPicker(selection: $fontFamily)
            //                }
            //                ColorPickerCompat(selection: $color)
            //            }
            Spacer()
        }.padding()
    }
    
    private var signatureContent: some View {
        return Group {
            if selectedTab == .draw {
                SignatureDrawView(drawing: $drawing,
                                  fontFamily: $fontFamily,
                                  color: .constant(.black))
            } else if selectedTab == .image {
                SignatureImageView(isSet: $isImageSet, selection: $image)
            } else if selectedTab == .type {
                SignatureTypeView(text: $text,
                                  fontFamily: $fontFamily,
                                  color: $color)
            }
        }.padding(.vertical)
    }
    
    private func extractImageAndHandle() {
        let image: UIImage
        switch selectedTab {
        case .draw:
            let path = drawing.cgPath
            let maxX = drawing.points.map { $0.x }.max() ?? 0
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: maxX, height: maxHeight))
            let uiImage = renderer.image { ctx in
                ctx.cgContext.setStrokeColor(color.uiColor.cgColor)
                ctx.cgContext.setLineWidth(lineWidth)
                ctx.cgContext.beginPath()
                ctx.cgContext.addPath(path)
                ctx.cgContext.drawPath(using: .stroke)
            }
            image = uiImage
        case .image:
            image = self.image
        case .type:
            let large = renderSigImages(size: .large, color: .white)
            let small = renderSigImages(size: .small, color: .black)
            
            
            images.append(.init(type: .large, image: large))
            images.append(.init(type: .small, image: small))
            
            image = large
//            let rendererWidth: CGFloat = 200
//            let rendererHeight: CGFloat = 64
//            let renderer = UIGraphicsImageRenderer(size: CGSize(width: rendererWidth, height: rendererHeight))
//            let uiImage = renderer.image { ctx in
//                let paragraphStyle = NSMutableParagraphStyle()
//                paragraphStyle.alignment = .center
//                
//                let attrs = [NSAttributedString.Key.font: UIFont(name: fontFamily, size: bigFontSize)!,
//                             NSAttributedString.Key.foregroundColor: color.uiColor,
//                             NSAttributedString.Key.paragraphStyle: paragraphStyle
//                ]
//                text.draw(with: CGRect(x: 0, y: 0, width: rendererWidth, height: rendererHeight),
//                          options: .usesLineFragmentOrigin,
//                          attributes: attrs,
//                          context: nil)
//            }
//            image = uiImage
        }
        if saveSignature {
            if let data = image.pngData(),
               let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let filename = docsDir.appendingPathComponent("Signature-\(Date()).png")
                try? data.write(to: filename)
            }
        }
        onSave(image, images)
    }
    
    private func clear() {
        drawing = DrawingPath()
        image = UIImage()
        isImageSet = false
        text = ""
    }
    
    public enum Tab: CaseIterable, Hashable {
        case draw, image, type
        
        var title: LocalizedStringKey {
            switch self {
            case .draw:
                return "Draw"
            case .image:
                return "Image"
            case .type:
                return "Type"
            }
        }
    }
    
    public enum SigImgSize {
        case large, small, all
    }
    
    fileprivate func renderSigImages(size: SigImgSize, color: UIColor = .black) -> UIImage {
        let rendererWidth: CGFloat = size == .large  ? 512 : 200
        let rendererHeight: CGFloat = size == .large ? 128 : 64
        let fontSize: CGFloat = size == .large ? 64 : 32
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: rendererWidth, height: rendererHeight))
        let uiImage = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs = [NSAttributedString.Key.font: UIFont(name: fontFamily, size: fontSize)!,
                         NSAttributedString.Key.foregroundColor: color,
                         NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
            text.draw(with: CGRect(x: 0, y: 0, width: rendererWidth, height: rendererHeight),
                      options: .usesLineFragmentOrigin,
                      attributes: attrs,
                      context: nil)
        }
        return uiImage
    }
}

struct ColorPickerCompat: View {
    @Binding var selection: Color
    
    @State private var showPopover = false
    private let availableColors: [Color] = [.blue, .black, .red]
    
    var body: some View {
        if #available(iOS 14.0, *) {
            ColorPicker(selection: $selection) {
                EmptyView()
            }
        } else {
            Button(action: {
                showPopover.toggle()
            }, label: {
                colorCircle(selection)
            }).popover(isPresented: $showPopover) {
                ForEach(availableColors, id: \.self) { color in
                    Button(action: {
                        selection = color
                        showPopover.toggle()
                    }, label: {
                        colorCircle(color)
                    })
                }
            }
        }
    }
    
    private func colorCircle(_ color: Color) -> some View {
        Circle()
            .foregroundColor(color)
            .frame(width: 32, height: 32)
    }
}

struct FontFamilyPicker: View {
    @Binding var selection: String
    
    @State private var showPopover = false
    
    var body: some View {
        Button(action: {
            showPopover.toggle()
        }, label: {
            buttonLabel(selection, size: 16)
        }).popover(isPresented: $showPopover) {
            VStack(spacing: 20) {
                ForEach(fontFamlies, id: \.self) { fontFamily in
                    Button(action: {
                        selection = fontFamily
                        showPopover.toggle()
                    }, label: {
                        buttonLabel(fontFamily, size: 24)
                    })
                }
            }
        }
    }
    
    private func buttonLabel(_ fontFamily: String, size: CGFloat) -> Text {
        Text(placeholderText)
            .font(.custom(fontFamily, size: size))
            .foregroundColor(.black)
    }
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct SignatureDrawView: View {
    @Binding var drawing: DrawingPath
    @Binding var fontFamily: String
    @Binding var color: Color
    
    @State private var drawingBounds: CGRect = .zero
    
    var body: some View {
        ZStack {
            Color.white
                .background(GeometryReader { geometry in
                    Color.clear.preference(key: FramePreferenceKey.self,
                                           value: geometry.frame(in: .local))
                })
                .onPreferenceChange(FramePreferenceKey.self) { bounds in
                    drawingBounds = bounds
                }
            if drawing.isEmpty {
                Text(placeholderText)
                    .foregroundColor(.gray)
                    .font(.custom(fontFamily, size: bigFontSize))
            } else {
                DrawShape(drawingPath: drawing)
                    .stroke(lineWidth: lineWidth)
                    .foregroundColor(color)
            }
        }
        .frame(height: maxHeight)
        .gesture(DragGesture()
            .onChanged( { value in
                if drawingBounds.contains(value.location) {
                    drawing.addPoint(value.location)
                } else {
                    drawing.addBreak()
                }
            }).onEnded( { value in
                drawing.addBreak()
            }))
        .overlay(RoundedRectangle(cornerRadius: 4)
            .stroke(Color.gray))
    }
}

struct DrawingPath {
    private(set) var points = [CGPoint]()
    private var breaks = [Int]()
    
    var isEmpty: Bool {
        points.isEmpty
    }
    
    mutating func addPoint(_ point: CGPoint) {
        points.append(point)
    }
    
    mutating func addBreak() {
        breaks.append(points.count)
    }
    
    var cgPath: CGPath {
        let path = CGMutablePath()
        guard let firstPoint = points.first else { return path }
        path.move(to: firstPoint)
        for i in 1..<points.count {
            if breaks.contains(i) {
                path.move(to: points[i])
            } else {
                path.addLine(to: points[i])
            }
            
        }
        return path
    }
    
    var path: Path {
        var path = Path()
        guard let firstPoint = points.first else { return path }
        path.move(to: firstPoint)
        for i in 1..<points.count {
            if breaks.contains(i) {
                path.move(to: points[i])
            } else {
                path.addLine(to: points[i])
            }
            
        }
        return path
    }
}

struct DrawShape: Shape {
    let drawingPath: DrawingPath
    
    func path(in rect: CGRect) -> Path {
        drawingPath.path
    }
}

struct SignatureImageView: View {
    @Binding var isSet: Bool
    @Binding var selection: UIImage
    
    @State private var showPopover = false
    
    var body: some View {
        Button(action: {
            showPopover.toggle()
        }) {
            if isSet {
                Image(uiImage: selection)
                    .resizable()
                    .frame(maxHeight: maxHeight,alignment: .leading)
            } else {
                ZStack {
                    Color.white
                    Text("Choose signature image")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                }.frame(height: maxHeight)
                    .overlay(RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray))
            }
        }.popover(isPresented: $showPopover) {
            SigImagePicker(selectedImage: $selection, didSet: $isSet)
        }
    }
}

struct SigImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    @Binding var selectedImage: UIImage
    @Binding var didSet: Bool
    var sourceType = UIImagePickerController.SourceType.photoLibrary
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SigImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.navigationBar.tintColor = .clear
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<SigImagePicker>) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let control: SigImagePicker
        
        init(_ control: SigImagePicker) {
            self.control = control
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                control.selectedImage = image
                control.didSet = true
            }
            control.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct SignatureTypeView: View {
    @Binding var text: String
    @Binding var fontFamily: String
    @Binding var color: Color
    
    var body: some View {
        TextField(placeholderText, text: $text)
            .disableAutocorrection(true)
            .font(.custom(fontFamily, size: bigFontSize))
            .foregroundColor(color)
    }
}

extension Color {
    var uiColor: UIColor {
        if #available(iOS 14, *) {
            return UIColor(self)
        } else {
            let components = self.components
            return UIColor(red: components.r, green: components.g, blue: components.b, alpha: components.a)
        }
    }
    
    private var components: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
        var hexNumber: UInt64 = 0
        var r: CGFloat = 0.0, g: CGFloat = 0.0, b: CGFloat = 0.0, a: CGFloat = 0.0
        let result = scanner.scanHexInt64(&hexNumber)
        if result {
            r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
            g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
            b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
            a = CGFloat(hexNumber & 0x000000ff) / 255
        }
        return (r, g, b, a)
    }
}
