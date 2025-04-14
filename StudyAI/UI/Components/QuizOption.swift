//
//  Untitled.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 5/4/25.
//

import SwiftUI

struct QuizOption: View {
    private var option: Option
    private var onItemClick: (UUID) -> Void
    private var selectedOptionID: UUID?
    private var showResult: Bool
    private var correctOptionID: UUID?
    
    init(
        option: Option,
        onItemClick: @escaping (UUID) -> Void,
        selectedOptionID: UUID?,
        showResult: Bool,
        correctOptionID: UUID?
    ) {
        self.option = option
        self.onItemClick = onItemClick
        self.selectedOptionID = selectedOptionID
        self.showResult = showResult
        self.correctOptionID = correctOptionID
    }
    
    private var backgroundColor: Color {
       if selectedOptionID == option.id {
           if correctOptionID == selectedOptionID {
               return .green
           } else {
               return .red
           }
       }
       return .white
    }

    var body: some View {
        if showResult {
            HStack {
                Text(option.text)
                    .padding()
                Spacer()
            }
            .foregroundStyle(option.id == selectedOptionID ? Color.white : Color.black)
            .background((backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 8)))
        }
        else {
            HStack {
                Text(option.text)
                    .padding()
                Spacer()
            }
            .background((option.id == selectedOptionID ? Color.purple : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 8)))
            .foregroundStyle(option.id == selectedOptionID ? Color.white : Color.black)
            .onTapGesture {
                onItemClick(option.id)
            }
        }
    }
}
