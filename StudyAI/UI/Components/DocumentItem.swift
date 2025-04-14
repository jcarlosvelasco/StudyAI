//
//  DocumentItem.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 27/3/25.
//

import SwiftUI

struct DocumentItem: View {
    private let documentName: String
    private var onSelect: () -> Void
    private var isSelected: Bool
    
    init(
        documentName: String,
        onSelect: @escaping () -> Void,
        isSelected: Bool
    ) {
        self.documentName = documentName
        self.onSelect = onSelect
        self.isSelected = isSelected
    }
    
    var body: some View {
        VStack {
            if isSelected {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.tint)
                    .frame(width: 80, height: 100)
            }
            else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.secondary)
                    .frame(width: 80, height: 100)
            }
            Text(documentName)
                .lineLimit(1)
                .truncationMode(.middle)
        }
        .frame(width: 120)
        .onTapGesture {
            onSelect()
        }
    }
}

struct DocumentItem_Previews: PreviewProvider {
    static var previews: some View {
        DocumentItem(
            documentName: "Hello.jfasdnflasndflandfl.pdf",
            onSelect: {},
            isSelected: false
        )
    }
}
