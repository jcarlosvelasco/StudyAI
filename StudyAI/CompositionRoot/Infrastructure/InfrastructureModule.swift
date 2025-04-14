//
//  InfrastructureModule.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 23/3/25.
//

import Factory

extension Container {
    var getDatabase: Factory<DatabaseInfrastructureType> {
        self {
            Database(modelContainer: DependencyContainer.shared.modelContainer)
        }
        .singleton
    }
    
    var getPDFReader: Factory<PDFReaderInfrastructureType> {
        self {
            PDFReader()
        }
        .singleton
    }
    
    var llm: Factory<LLMInfrastructureType> {
        self {
            LLMInfrastructure()
        }
        .singleton
    }
}
