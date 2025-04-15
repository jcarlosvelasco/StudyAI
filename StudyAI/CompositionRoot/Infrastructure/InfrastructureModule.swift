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
    
    var urlSessionHTTPClient: Factory<HTTPClient> {
        self {
            URLSessionHTTPClient(
                requestMaker: Container.shared.urlSessionRequestMaker(),
                errorResolver: Container.shared.urlSessionErrorResolver()
            )
        }
        .singleton
    }
    
    var urlSessionRequestMaker: Factory<URLSessionRequestMaker> {
        self {
            URLSessionRequestMaker()
        }
        .singleton
    }
    
    var urlSessionErrorResolver: Factory<URLSessionErrorResolver> {
        self {
            URLSessionErrorResolver()
        }
        .singleton
    }
}
