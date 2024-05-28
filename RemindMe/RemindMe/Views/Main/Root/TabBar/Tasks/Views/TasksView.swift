//
//  TasksView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import Components
import Design
import Navigation
import SwiftUI
import ToDoInterface

struct TasksView: View {
    
    @StateObject private var viewModel = TasksViewModel()
    @EnvironmentObject private var router: Router<Routes>
    
    var body: some View {
        ZStack {
            if viewModel.tasks.isEmpty {
                buildViewWithoutTasks
            } else {
                buildTaskView
            }
        }
        .task {
            await viewModel.getAllTasks()
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
            ScrollView {
                ForEach(viewModel.tasks, id: \.id) { task in
                    TaskTile(category: task.category.rawValue, title: task.name, isDone: .constant(false), latestTask: .constant(ToDo(category: .birthday, name: "", toDoDescription: "", executedTime: Date(), numbersOfReminders: 1))) { test in
                            print(task)
                    } isEdited: { test in
                        print(test)
                    }
                    .padding(.vertical, 10)
                }
                .padding(.vertical, 20)
            }
            .withFadeOut(topFadeLength: 30, bottomFadeLength: 100)
        }
        .padding()
    }
}
