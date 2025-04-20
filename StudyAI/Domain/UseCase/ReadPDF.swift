//
//  ReadPDF.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 26/3/25.
//

import Foundation

protocol ReadPDFType {
    func execute(documentURL: URL) async -> Result<String, DocumentDomainError>
}

class ReadPDF: ReadPDFType {
    private let readPDFRepository: ReadPDFRepositoryType
    
    init(readPDFRepository: ReadPDFRepositoryType) {
        self.readPDFRepository = readPDFRepository
    }
    
    func execute(documentURL: URL) async -> Result<String, DocumentDomainError> {
        return await readPDFRepository.readPDF(documentURL: documentURL)
    }
}
