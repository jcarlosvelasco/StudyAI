//
//  UseCaseModule.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 23/3/25.
//

import Factory

extension Container {
    var getSubjects: Factory<GetSubjectsType> {
        self {
            GetSubjects(getSubjectsRepo: Container.shared.getSubjectsRepository())
        }
        .singleton
    }
    
    var getAddSubject: Factory<AddSubjectType> {
        self {
            AddSubject(addSubjectRepository: Container.shared.addSubjectRepository())
        }
        .singleton
    }
    
    var addDocumentsToSubject: Factory<AddDocumentsToSubjectType> {
        self {
            AddDocumentsToSubject(addDocumentsToSubjectRepository: Container.shared.addDocumentsToSubjectRepository())
        }
        .singleton
    }
    
    var deleteSubject: Factory<DeleteSubjectType> {
        self {
            DeleteSubject(deleteSubjectRepository: Container.shared.deleteSubjectRepository())
        }
        .singleton
    }
    
    var getSubject: Factory<GetSubjectType> {
        self {
            GetSubject(getSubjectRepository: Container.shared.getSubjectRepository())
        }
        .singleton
    }
    
    var deleteDocumentFromSubject: Factory<DeleteDocumentFromSubjectType> {
        self {
            DeleteDocumentFromSubject(deleteDocumentFromSubjectRepo: Container.shared.deleteDocumentFromSubjectRepository())
        }
        .singleton
    }
    
    var readPDF: Factory<ReadPDFType> {
        self {
            ReadPDF(readPDFRepository: Container.shared.readPDFRepository())
        }
        .singleton
    }
    
    var createQuiz: Factory<CreateQuizType> {
        self {
            CreateQuiz(
                createQuizRepository: Container.shared.createQuizRepositoryType(),
                readPDF: self.readPDF()
            )
        }
        .singleton
    }
    
    var getQuizes: Factory<GetQuizesType> {
        self {
            GetQuizes(
                getQuizesRepository: Container.shared.getQuizesRepository()
            )
        }
        .singleton
    }
    
    var storeQuiz: Factory<StoreQuizType> {
        self {
            StoreQuiz(
                storeQuizRepository: Container.shared.storeQuizRepository()
            )
        }
        .singleton
    }
    
    var deleteQuiz: Factory<DeleteQuizType> {
        self {
            DeleteQuiz(deleteQuizRepository: Container.shared.deleteQuizRepository())
        }
        .singleton
    }
    
    var updateQuizOnCompletion: Factory<UpdateQuizOnCompletionType> {
        self {
            UpdateQuizOnCompletion(updateQuizOnCompletionRepository: Container.shared.updateQuizOnCompletionRepository())
        }
        .singleton
    }
    
    var updateSubject: Factory<UpdateSubjectType> {
        self {
            UpdateSubject(updateSubjectRepositoryType: Container.shared.updateSubjectRepository())
        }
        .singleton
    }
    
    var getAIScoreText: Factory<GetAIScoreTextType> {
        self {
            GetAIScore(getAIScoreTextRepo: Container.shared.getAIScoreTextRepository())
        }
        .singleton
    }
}
