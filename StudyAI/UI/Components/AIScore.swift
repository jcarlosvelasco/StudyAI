//
//  AIScore.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 8/4/25.
//

import SwiftUI


struct AIScore: View {
    private var score: Int
    private var text: String?
        
    init(score: Int, text: String?) {
        self.score = score
        self.text = text
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("AI Score")
                .font(.title3)
                .bold()
                .padding(.bottom)
            
            HStack {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 12)
                        .opacity(0.2)
                        .foregroundColor(.blue)

                    Circle()
                        .trim(from: 0.0, to: CGFloat(score) / 100)
                        .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.blue)
                        .rotationEffect(Angle(degrees: -90))
                        .animation(.easeOut(duration: 0.8), value: score)

                    Text(score.description)
                        .font(.title)
                        .bold()
                }
                .frame(width: 70, height: 70)
                .padding(.trailing)
                
                
                Text(text ?? "-")
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    AIScore(score: 50, text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.")
}
