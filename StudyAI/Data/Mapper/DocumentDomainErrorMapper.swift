//
//  DocumentDomainErrorMapper.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 20/4/25.
//

class DocumentDomainErrorMapper {
    func map(error: PDFReaderError) -> DocumentDomainError {
        switch error {
            case .invalidFormat:
                return .invalidFormat
            case .generic:
                return .generic
        }
    }
}
