//
//  Option.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 27/3/25.
//

import Foundation

class Option {
    let id: UUID
    let text: String
    
    init(
        id: UUID = UUID(),
        text: String
    ) {
        self.id = id
        self.text = text
    }
}
