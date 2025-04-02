//
//  PDFCreator.swift
//  zala
//
//  Created by Kyle Carriedo on 9/18/24.
//

import Foundation
import UIKit
import PDFKit
import SwiftUI

class PDFCreator {
    var titleSub: NSMutableAttributedString = NSMutableAttributedString()
    
    func textAttachment(images:[UIImage]) -> NSAttributedString?  {
        if let image = images.first {
            let attachment = NSTextAttachment()
            attachment.image = image
            return NSAttributedString(attachment: attachment)
        } else {
            return nil
        }
    }
    
    func pdfAttributed(consent: ConsentTemplateModel, images:[UIImage]) -> NSAttributedString {
        
        if let textImage =  textAttachment(images: images) {
            titleSub.append(textImage)
            let title = ("\n\(consent.title)\n").toAttributedString
            titleSub.append(title)
                        
        } else {
            let title = consent.title.toAttributedString
            titleSub = NSMutableAttributedString(attributedString: title)
        }
        
        if let subtitle = consent.subtitle {
            let subtitle = ("\n\(subtitle)\n").toAttributedString
            titleSub.append(subtitle)
        }
        
        if let content = consent.content {
            let detail  = ("\n\(content)\n").toAttributedString
            titleSub.append(detail)
        }
        
        for section in consent.sections {
            if let title = section.title {
                titleSub.append(("\n\(title)\n").toAttributedString)
            }
            
            if let content = section.content {
                titleSub.append(("\n\(content)\n").toAttributedString)
            }
            
            for field in section.fields {
                if field.type == .checkboxwithvalue, let key = field.content {
                    let imageAttachment = NSTextAttachment()
                    imageAttachment.image = field.selectionValue ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
                    imageAttachment.bounds = CGRect(x: 0, y: -2, width: 10, height: 10)
                    let image1String = NSAttributedString(attachment: imageAttachment)
                    titleSub.append(image1String)
                    
                    titleSub.append("   \(key)".toAttributedString)
                    titleSub.append(" \(field.value)\n".toAttributedString)
                    
                } else if field.type == .checkbox, let key = field.content {
                    let imageAttachment = NSTextAttachment()
                    imageAttachment.image = field.selectionValue ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
                    imageAttachment.bounds = CGRect(x: 0, y: -2, width: 10, height: 10)
                    let image1String = NSAttributedString(attachment: imageAttachment)
                    titleSub.append(image1String)
                    
                    titleSub.append("   \(key)".toAttributedString)
                    titleSub.append(" \(field.content ?? "")\n".toAttributedString)
                    
                } else if let key = field.key {
                    titleSub.append("\n\(key)\n".toAttributedString)
                    titleSub.append("\(field.value)\n".toAttributedString)
                } else {
                    titleSub.append("\(field.value)\n".toAttributedString)
                }
                
                if field.type == .signature, let img = field.sigImage {
                    let image1Attachment = NSTextAttachment()
                    image1Attachment.image = img
                    let image1String = NSAttributedString(attachment: image1Attachment)
                    titleSub.append(image1String)
                }
            }
        }
        return titleSub
    }
    
    func createPDF(attributedString: NSAttributedString, images: [UIImage]) -> Data? {
        let pageSize = CGSize(width: 612, height: 792) // Letter size (8.5 x 11 inches)
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize))
        
        var pdfData = Data()
        
        let chunks = chunkAttributedString(attributedString, pageSize: pageSize) // Calculate chunks based on page size
        
        pdfData = renderer.pdfData { context in
            var currentPage = 0
            for chunk in chunks {
                currentPage += 1
                context.beginPage()
                drawPageContent(chunk, currentPage: currentPage, pageSize: pageSize)
            }
        }
        return pdfData
    }
    
    private func drawPageContent(_ attributedString: NSAttributedString, currentPage: Int, pageSize: CGSize) {
        let textRect = CGRect(x: 50, y: 50, width: pageSize.width - 100, height: pageSize.height - 100)
        attributedString.draw(in: textRect)
    }
    
    
    private func chunkAttributedString(_ attributedString: NSAttributedString, pageSize: CGSize) -> [NSAttributedString] {
        var chunks = [NSAttributedString]()
        var currentIndex = 0
        
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage(attributedString: attributedString)
        textStorage.addLayoutManager(layoutManager)
        
        while currentIndex < attributedString.length {
            let textContainer = NSTextContainer(size: CGSize(width: pageSize.width - 100, height: pageSize.height - 100))
            layoutManager.addTextContainer(textContainer)
            
            let characterRange = NSRange(location: currentIndex, length: attributedString.length - currentIndex)
            let glyphRange = layoutManager.glyphRange(for: textContainer)
            
            // Ensure the current glyph range does not exceed the character range
            let effectiveGlyphRange = NSRange(location: glyphRange.location, length: min(glyphRange.length, characterRange.length))
            
            let chunk = attributedString.attributedSubstring(from: effectiveGlyphRange)
            chunks.append(chunk)
            
            currentIndex += effectiveGlyphRange.length
        }
        
        return chunks
    }
}




// PDF Viewer
struct PDFKitView: UIViewRepresentable {
    
    let pdfDocument: PDFDocument
    
    init(pdfData pdfDoc: PDFDocument) {
        self.pdfDocument = pdfDoc
    }
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDocument
    }
}


extension String {
    var toAttributedString: NSAttributedString {
        do {
            return try NSAttributedString(markdown: self,
                                          options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
        } catch {
            return NSAttributedString(string:"Error parsing markdown: \(error)")
        }
    }
}
