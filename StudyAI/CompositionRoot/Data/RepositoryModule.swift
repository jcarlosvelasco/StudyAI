//
//  RepositoryModule.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 23/3/25.
//

import Factory

extension Container {
    private var subjectRepository: Factory<SubjectRepository> {
        self {
            SubjectRepository(
                database: Container.shared.getDatabase(),
                subjectEntityMapper: Container.shared.getSubjectEntityMapper(),
                subjectMapper: Container.shared.getSubjectMapper(),
                mapper: Container.shared.apiResponseMapper(),
                apiDataSource: Container.shared.apiDataSource(),
                errorMapper: Container.shared.subjectDomainErrorMapper()
            )
        }
        .singleton
    }

    var getSubjectsRepository: Factory<GetSubjectsRepositoryType> {
        self { self.subjectRepository() }
            .singleton
    }

    var addSubjectRepository: Factory<AddSubjectRepositoryType> {
        self { self.subjectRepository() }
            .singleton
    }
    
    var addDocumentsToSubjectRepository: Factory<AddDocumentsToSubjectRepositoryType> {
        self { self.subjectRepository() }
            .singleton
    }
    
    var deleteSubjectRepository: Factory<DeleteSubjectRepositoryType> {
        self { self.subjectRepository() }
            .singleton
    }
    
    var getSubjectRepository: Factory<GetSubjectRepositoryType> {
        self { self.subjectRepository() }
            .singleton
    }
    
    var deleteDocumentFromSubjectRepository: Factory<DeleteDocumentFromSubjectRepositoryType> {
        self { self.subjectRepository() }
            .singleton
    }
    
    var updateSubjectRepository: Factory<UpdateSubjectRepositoryType> {
        self {
            self.subjectRepository()
        }
        .singleton
    }
    
    var getAIScoreTextRepository: Factory<GetAIScoreRepositoryType> {
        self {
            self.subjectRepository()
        }
        .singleton
    }
    
    private var documentRepository: Factory<DocumentRepository> {
        self {
            DocumentRepository(pdfReader: Container.shared.getPDFReader())
        }
        .singleton
    }
    
    var readPDFRepository: Factory<ReadPDFRepositoryType> {
        self {
            self.documentRepository()
        }
        .singleton
    }
    
    private var llmRepository: Factory<LLMRepository> {
        self {
            LLMRepository(
                mapper: Container.shared.apiResponseMapper(),
                apiDataSource: Container.shared.apiDataSource(),
                errorMapper: Container.shared.quizDomainErrorMapper()
            )
        }
        .singleton
    }
    
    var createQuizRepositoryType: Factory<CreateQuizRepositoryType> {
        self {
            self.llmRepository()
        }
        .singleton
    }
    
    private var quizRepository: Factory<QuizRepository> {
        self {
            QuizRepository(
                quizMapper: Container.shared.quizMapper(),
                database: Container.shared.getDatabase(),
                quizEntityMapper: Container.shared.quizEntityMapper()
            )
        }
        .singleton
    }
    
    var getQuizesRepository: Factory<GetQuizesRepositoryType> {
        self {
            self.quizRepository()
        }
        .singleton
    }
    
    var storeQuizRepository: Factory<StoreQuizRepositoryType> {
        self {
            self.quizRepository()
        }
        .singleton
    }
    
    var deleteQuizRepository: Factory<DeleteQuizRepositoryType> {
        self {
            self.quizRepository()
        }
        .singleton
    }
    
    var updateQuizOnCompletionRepository: Factory<UpdateQuizOnCompletionRepositoryType> {
        self {
            self.quizRepository()
        }
        .singleton
    }
}
