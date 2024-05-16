//
//  TasksView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import Design
import Navigation
import SwiftUI

struct TasksView: View {
    
    @StateObject private var viewModel = TasksViewModel()
    @EnvironmentObject private var router: Router<Routes>
    
    var body: some View {
        if viewModel.tasks.isEmpty {
            buildViewWithoutTasks
//                .withModal(.sheet, destinationView: AddTaskView(), isPresented: $viewModel.isSheetPresented, presentationDetent: .height(550))
        } else {
            buildTaskView
        }
    }
}

#Preview {
    ZStack {
        Colors.background().ignoresSafeArea()
        TasksView()
    }
}

extension TasksView {
    private var buildViewWithoutTasks: some View {
        VStack(spacing: 20) {
            Text("You don't have any task yet, click PLUS button to add one")
                .foregroundStyle(Colors.ghostWhite.opacity(0.5))
                .multilineTextAlignment(.center)
            Button {
//                viewModel.withSheetPreseted()
                router.navigate(to: .addTask)
            } label: {
                Image(systemName: Symbols.plusCircle)
                    .font(.system(size: 100))
                    .foregroundStyle(Colors.ghostWhite.opacity(0.2))
            }
        }
        .frame(maxWidth: 250)
    }
    
    private var buildTaskView: some View {
        VStack {
            
        }
        
    }
}
