//
//  DocumentRepository.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 26/3/25.
//

import Foundation

class DocumentRepository:
    ReadPDFRepositoryType
{
    private let pdfReader: PDFReaderInfrastructureType
    
    init(pdfReader: PDFReaderInfrastructureType) {
        self.pdfReader = pdfReader
    }
    
    func readPDF(documentURL: URL) async -> String? {
        return await pdfReader.readPDF(documentURL: documentURL)
    }
}
