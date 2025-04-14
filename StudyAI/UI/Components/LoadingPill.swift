//
//  LoadingPill.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 1/4/25.
//

import SwiftUI

struct LoadingPill: View {
    private let text: String
    private let progress: Double
    
    init(text: String, progress: Double) {
        self.text = text
        self.progress = progress
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(text)
                Spacer()
            }
            ProgressView(value: progress, total: 100)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8.0)
    }
}

#Preview {
    LoadingPill(
        text: "Downloading model",
        progress: 7.0
    )
}
