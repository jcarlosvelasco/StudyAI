//
//  SubjectRowItem.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 24/3/25.
//

import SwiftUI

struct SubjectRowItem: View {
    private var subjectName: String
    private var onDelete: () -> Void
    
    init(
        subjectName: String,
        onDelete: @escaping () -> Void
    ) {
        self.subjectName = subjectName
        self.onDelete = onDelete
    }
    
    var body: some View {
       Text(subjectName)
            .contextMenu {
               Button(role: .destructive) {
                   onDelete()
               } label: {
                   Label("Delete", systemImage: "trash")
               }
           }
    }
}
