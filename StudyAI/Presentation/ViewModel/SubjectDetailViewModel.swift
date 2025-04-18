//
//  SubjectDetailViewModel.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 24/3/25.
//

import Foundation
import Factory

class SubjectDetailViewModel: ObservableObject {
    let subject: Subject
    let allowedMultipleFiles = Config.allowMultipleFiles
    let allowedFileExtensions = Config.allowedFileExtensions
    
    @Published var filePaths: [URL] = []
    @Published var isImporting = false
    @Published var showCreateQuizSheet: Bool = false
    @Published var newQuizName: String = ""
    @Published var selectedFiles: [URL] = []
    @Published var shouldNavigateToQuiz = false
    @Published var quizes: [Quiz] = []
    @Published var isLoading: Bool = false
    @Published var score: Int = 0
    @Published var scoreText: String?
    @Published var showErrorAlert: Bool = false
    
    private let addDocumentsToSubject: AddDocumentsToSubjectType
    private let getSubject: GetSubjectType
    private let deleteDocumentFromSubject: DeleteDocumentFromSubjectType
    private let readPdf: ReadPDFType
    private let createQuiz: CreateQuizType
    private let getQuizes: GetQuizesType
    private let storeQuiz: StoreQuizType
    private let deleteQuiz: DeleteQuizType
    private let updateSubject: UpdateSubjectType
    private let getAIScore: GetAIScoreTextType
    private let quizPresentableErrorMapper: QuizPresentableErrorMapper
    private let subjectPresentableErrorMapper: SubjectPresentableErrorMapper
    
    var quiz: Quiz?
    var errorMessage: String = ""
    
    init(
        subject: Subject,
        addDocumentsToSubject: AddDocumentsToSubjectType = Container.shared.addDocumentsToSubject(),
        getSubject: GetSubjectType = Container.shared.getSubject(),
        deleteDocumentFromSubject: DeleteDocumentFromSubjectType = Container.shared.deleteDocumentFromSubject(),
        readPDF: ReadPDFType = Container.shared.readPDF(),
        createQuiz: CreateQuizType = Container.shared.createQuiz(),
        getQuizes: GetQuizesType = Container.shared.getQuizes(),
        storeQuiz: StoreQuizType = Container.shared.storeQuiz(),
        deleteQuiz: DeleteQuizType = Container.shared.deleteQuiz(),
        updateSubject: UpdateSubjectType = Container.shared.updateSubject(),
        getAIScore: GetAIScoreTextType = Container.shared.getAIScoreText(),
        quizPresentableErrorMapper: QuizPresentableErrorMapper = Container.shared.quizPresentableErrorMapper(),
        subjectPresentableErrorMapper: SubjectPresentableErrorMapper = Container.shared.subjectPresentableErrorMapper()
    ) {
        Logger.log(.info, "Init")
        self.subject = subject
        self.addDocumentsToSubject = addDocumentsToSubject
        self.getSubject = getSubject
        self.deleteDocumentFromSubject = deleteDocumentFromSubject
        self.readPdf = readPDF
        self.createQuiz = createQuiz
        self.getQuizes = getQuizes
        self.storeQuiz = storeQuiz
        self.deleteQuiz = deleteQuiz
        self.updateSubject = updateSubject
        self.getAIScore = getAIScore
        self.quizPresentableErrorMapper = quizPresentableErrorMapper
        self.subjectPresentableErrorMapper = subjectPresentableErrorMapper
        
        Task {
            await getDocuments(subjectID: subject.id)
        }
    }
    
    deinit {
        Logger.log(.info, "deinit")
    }
    
    func fetchQuizzes() async {
        Logger.log(.info, "Fetch quizzes")

        let result = await getQuizes.execute(subjectID: subject.id)
        guard case .success(let quizzes) = result else {
            if case .failure(let error) = result {
                handleQuizError(error: error)
            } else {
                handleQuizError(error: nil)
            }
            return
        }
        
        DispatchQueue.main.async {
            self.quizes = quizzes
        }
        
        if quizzes.isEmpty {
            return
        }
        
        let updatedSubjectResult = await getSubject.execute(subjectID: subject.id)
        guard case .success(let updatedSubject?) = updatedSubjectResult else {
            if case .failure(let error) = updatedSubjectResult {
                handleSubjectError(error: error)
            } else {
                handleSubjectError(error: nil)
            }
            return
        }
        
        Logger.log(.info, "Fetch Quizzes, updated subject: \(updatedSubject.lastAIScoreUpdate?.description ?? "nil")")
        
        DispatchQueue.main.async {
            self.score = updatedSubject.score
            self.scoreText = updatedSubject.scoreText
        }
        
        if updatedSubject.lastAIScoreUpdate == nil {
            Logger.log(.info, "SubjectDetailViewModel, Last AI Score update is nil, calculating score...")
            DispatchQueue.main.async {
                self.score = 0
            }
        }
        else {
            var biggestDate: Date = Date.distantPast
            for quiz in quizzes {
                if let date = quiz.lastTimeCompleted {
                    if date.timeIntervalSince1970 > biggestDate.timeIntervalSince1970 {
                        biggestDate = date
                    }
                }
                else {
                    Logger.log(.info, "Nil date")
                }
            }
            
            Logger.log(.info, "Quiz last done date: \(biggestDate.description)")
            Logger.log(.info, "FetchQuizzes date: \(updatedSubject.lastAIScoreUpdate!.description)")

            if Int(updatedSubject.lastAIScoreUpdate!.timeIntervalSince1970) < Int(biggestDate.timeIntervalSince1970) {
                Logger.log(.info, "Subject last ai score update bigger than biggest date, calculating score...")
                await calculateScore(quizzes: quizzes)
            }
        }
    }
    
    func getDocuments(subjectID: UUID) async {
        let result = await getSubject.execute(subjectID: subjectID)
        guard case .success(let subject?) = result else {
            if case .failure(let error) = result {
                handleSubjectError(error: error)
            } else {
                handleSubjectError(error: nil)
            }
            return
        }
        
        DispatchQueue.main.async {
            self.filePaths = subject.fileURLs.map { $0 }
        }
    }
    
    func addDocuments(fileURLs: [URL]) async {
        let filteredFiles = fileURLs.filter { !self.filePaths.contains($0) }
        let result = await addDocumentsToSubject.execute(subjectID: subject.id, fileURLs: filteredFiles)
        guard case .success() = result else {
            if case .failure(let error) = result {
                handleSubjectError(error: error)
            } else {
                handleSubjectError(error: nil)
            }
            return
        }
        
        for fileURL in filteredFiles {
            DispatchQueue.main.async {
                self.filePaths.append(fileURL)
            }
        }
    }
    
    func onDelete(filePath: URL) async {
        let result = await self.deleteDocumentFromSubject.execute(subjectID: subject.id, filePath: filePath)
        guard case .success() = result else {
            if case .failure(let error) = result {
                handleSubjectError(error: error)
            } else {
                handleSubjectError(error: nil)
            }
            return
        }
        
        DispatchQueue.main.async {
            self.filePaths = self.filePaths.filter { $0 != filePath }
        }
    }
    
    func onDocumentSelect(path: URL) {
        if self.selectedFiles.contains(path) {
            DispatchQueue.main.async {
                self.selectedFiles.removeAll { $0 == path }
            }
        }
        else {
            DispatchQueue.main.async {
                self.selectedFiles.append(path)
            }
        }
    }
    
    func onCreateQuiz() async {
        DispatchQueue.main.async {
            self.isLoading.toggle()
        }
        
        let result = await createQuiz.execute(documentURLs: self.selectedFiles, name: newQuizName, subjectID: subject.id)
        guard case .success(let createdQuiz) = result else {
            if case .failure(let error) = result {
                handleQuizError(error: error)
            } else {
                handleQuizError(error: nil)
            }
            
            DispatchQueue.main.async {
                self.isLoading.toggle()
            }
            return
        }
        
        self.quiz = createdQuiz
        
        let storeQuizResult = await storeQuiz.execute(quiz: createdQuiz)
        guard case .success() = storeQuizResult else {
            if case .failure(let error) = storeQuizResult {
                handleQuizError(error: error)
            } else {
                handleQuizError(error: nil)
            }
            return
        }
        
        DispatchQueue.main.async {
            self.isLoading.toggle()
            self.shouldNavigateToQuiz = true
        }
    }
    
    func onDeleteQuiz(quizID: UUID) async {
        let result = await deleteQuiz.execute(quizID: quizID)
        guard case .success(let text) = result else {
            if case .failure(let error) = result {
                handleQuizError(error: error)
            } else {
                handleQuizError(error: nil)
            }
            return
        }
        
        let newQuizes = self.quizes.filter { $0.id != quizID }
        DispatchQueue.main.async {
            self.quizes = newQuizes
        }
        
        await calculateScore(quizzes: newQuizes)
    }
    
    func calculateScore(quizzes: [Quiz]) async {
        Logger.log(.info, "Calculate score")
        
        DispatchQueue.main.async {
            self.score = 0
            self.scoreText = nil
        }
        
        var totalQuestions = 0
        for quiz in quizzes {
            for _ in quiz.questions {
                totalQuestions += 1
            }
        }

        guard totalQuestions > 0 else {
            return
        }
        
        let totalScore = quizzes.reduce(0) { $0 + $1.highestScore }
        let score = (totalScore * 100) / totalQuestions
        Logger.log(.info, "Result: \(score)")
        
        if quizzes.isEmpty {
            return
        }
        
        let result = await getAIScore.execute(score: score, quizzes: quizes)
        guard case .success(let text) = result else {
            if case .failure(let error) = result {
                handleSubjectError(error: error)
            } else {
                handleSubjectError(error: nil)
            }
            self.isLoading.toggle()
            return
        }
        
        DispatchQueue.main.async {
            self.score = score
            self.scoreText = text
        }
        
        Task {
            await updateSubject.execute(subjectID: subject.id, score: score, scoreText: text)
        }
    }
}

extension SubjectDetailViewModel {
    private func handleQuizError(error: QuizDomainError?) {
        errorMessage = quizPresentableErrorMapper.map(error: error)
        DispatchQueue.main.async {
            self.showErrorAlert.toggle()
        }
    }
    
    private func handleSubjectError(error: SubjectDomainError?) {
        errorMessage = subjectPresentableErrorMapper.map(error: error)
        DispatchQueue.main.async {
            self.showErrorAlert.toggle()
        }
    }
}
