//
//  ReadPDFRepositoryType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 26/3/25.
//

import Foundation

protocol ReadPDFRepositoryType {
    func readPDF(documentURL: URL) async -> String?
}
