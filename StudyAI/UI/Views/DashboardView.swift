//
//  DashboardView.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 7/4/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel: DashboardViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            }
            .navigationTitle("Dashboard")
        }
    }
}

#Preview {
    DashboardView(viewModel: DashboardViewModel())
}
