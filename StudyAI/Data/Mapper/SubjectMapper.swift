//
//  SubjectMapper.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 23/3/25.
//

class SubjectMapper {
    func mapToSubjectEntity(subject: Subject) -> SubjectEntity {
        return SubjectEntity(
            id: subject.id,
            name: subject.name,
            filePaths: subject.fileURLs.map { FilePath(name: $0.absoluteString) },
            score: subject.score,
            scoreText: subject.scoreText,
            lastAIScoreUpdate: subject.lastAIScoreUpdate
        )
    }
}
