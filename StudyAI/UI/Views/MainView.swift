//
//  MainView.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 7/4/25.
//

import SwiftUI
import Factory

struct MainView: View {
    var body: some View {
        TabView {
            Tab("Dashboard", systemImage: "house") {
                DashboardView(viewModel: DashboardViewModel())
            }
            Tab("Subjects", systemImage: "books.vertical") {
                SubjectsView(
                    subjectsVM: SubjectsViewModel()
                )
            }
        }
    }
}

#Preview {
    MainView()
}
