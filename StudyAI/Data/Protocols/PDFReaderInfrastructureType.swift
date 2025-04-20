//
//  PDFReaderInfrastructureType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 26/3/25.
//

import Foundation

protocol PDFReaderInfrastructureType {
    func readPDF(documentURL: URL) async -> Result<String, PDFReaderError>
}
