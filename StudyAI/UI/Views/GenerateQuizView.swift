//
//  GenerateQuizView.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 7/4/25.
//

import SwiftUI
import BezelKit

struct GenerateQuizView: View {
    @State var isAnimating = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            MeshGradient(width: 3, height: 3, points: [
                        [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                        [0.0, 0.5], [isAnimating ? 0.1 : 0.8, 0.5], [1.0, isAnimating ? 0.5 : 1],
                        [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                    ], colors: [
                        .purple, .indigo, .blue,
                        isAnimating ? .purple : .purple, .pink, .blue,
                        .blue, .indigo, .purple
                    ])
            .ignoresSafeArea()
            
            RoundedRectangle(cornerRadius: CGFloat.deviceBezel - 2)
                .fill(colorScheme == .dark ? Color.black : Color.white)
                .padding(5)
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "sparkles")
                   .font(.system(size: 120, weight: .black))
                   .foregroundStyle(
                    MeshGradient(width: 3, height: 3, points: [
                                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                                [0.0, 0.5], [isAnimating ? 0.1 : 0.8, 0.5], [1.0, isAnimating ? 0.5 : 1],
                                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                            ], colors: [
                                .purple, .indigo, .blue,
                                isAnimating ? .purple : .indigo, .purple, .blue,
                                .blue, .indigo, .purple
                            ])
                   )
               Text("Generating quiz").foregroundStyle(
                MeshGradient(width: 3, height: 3, points: [
                            [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                            [0.0, 0.5], [isAnimating ? 0.1 : 0.8, 0.5], [1.0, isAnimating ? 0.5 : 1],
                            [0.0, 1.0], [0.5, 1.0], [1.0, 1.0]
                        ], colors: [
                            .purple, .indigo, .blue,
                            isAnimating ? .purple : .indigo, .purple, .blue,
                            .blue, .indigo, .purple
                        ])
               )
            }
        }
        .navigationBarHidden(true)
        .onAppear() {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating.toggle()
            }
        }
    }
}

#Preview {
    GenerateQuizView()
}
