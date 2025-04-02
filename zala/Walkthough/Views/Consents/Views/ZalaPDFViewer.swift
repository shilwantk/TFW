//
//  ZalaPDFViewer.swift
//  zala
//
//  Created by Kyle Carriedo on 9/18/24.
//

import Foundation
import PDFKit
import SwiftUI

struct PDFViewRepresentable: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true // Automatically scale the PDF to fit the view
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        if let pdfDocument = PDFDocument(data: data) {
            pdfView.document = pdfDocument
        }
    }
}
