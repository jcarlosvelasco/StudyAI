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
    private let errorMapper: DocumentDomainErrorMapper
    
    init(
        pdfReader: PDFReaderInfrastructureType,
        errorMapper: DocumentDomainErrorMapper
    ) {
        self.pdfReader = pdfReader
        self.errorMapper = errorMapper
    }
    
    func readPDF(documentURL: URL) async -> Result<String, DocumentDomainError> {
        if !FileManager.default.fileExists(atPath: documentURL.path) {
            return .failure(.fileNotFound)
        }
        
        let result = await pdfReader.readPDF(documentURL: documentURL)
        guard case .success(let string) = result else {
            guard case .failure(let failure) = result else {
                return .failure(.generic)
            }
            return .failure(errorMapper.map(error: failure))
        }

        return .success(string)
    }
}
