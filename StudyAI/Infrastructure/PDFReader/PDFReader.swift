//
//  PDFReader.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 25/3/25.
//

import PDFKit

class PDFReader: PDFReaderInfrastructureType {
    func readPDF(documentURL: URL) async -> String? {
        if let pdf = PDFDocument(url: documentURL) {
            let pageCount = pdf.pageCount
            let documentContent = NSMutableAttributedString()

            for i in 0 ..< pageCount {
                guard let page = pdf.page(at: i) else { continue }
                guard let pageContent = page.attributedString else { continue }
                documentContent.append(pageContent)
            }
            
            return documentContent.string
        }
        
        return nil
    }
}
