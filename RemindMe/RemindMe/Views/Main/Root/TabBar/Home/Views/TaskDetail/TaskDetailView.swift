//
//  TaskDetailView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 29/10/2024.
//

import Components
import Design
import SwiftUI
import ToDoInterface
import Utilities

struct TaskDetailView: View {
    @StateObject private var viewModel = TaskDetailViewModel()
    let task: ToDo?
    
    init(task: ToDo?) { self.task = task }
    
    var body: some View {
        if let task = task {
            VStack {
                VStack(spacing: 0) {
                    TaskInfoCellView(task: task, backgroundColor: .clear)
                        .padding(.horizontal, -16)
                    
                    ScrollView(.vertical) {
                        VStack(spacing: 10) {
                            ForEach(task.subtasks.indices, id: \.self) { index in
                                let subtask = task.subtasks[index]
                                
                                Row(
                                    text: subtask.title,
                                    variant: .subtaskWithCheckmark(subtask: subtask)
                                ) {
                                    Task {
                                        try await viewModel.updateSubtask(task: task,subtask: subtask)
                                    }
                                }
                            }
                            
                            Rectangle()
                                .frame(maxWidth: .infinity)
                                .frame(height: 340)
                                .opacity(0)
                                .overlay {
                                    if let uiImage = UIImage(data: task.image ?? Data()) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                    } else {
                                        VStack {
                                            Text("No photo")
                                                .font(.title)
                                                .fontWeight(.bold)
                                            
                                            Image(systemName: "photo.on.rectangle.angled")
                                                .resizable()
                                                .frame(width: 250, height: 200)
                                        }
                                        .foregroundColor(Colors.night.opacity(0.6))
                                    }
                                }
                                .clipShape(.rect(cornerRadius: 30))
                            
                            HStack {
                                Text("\(task.reminderRepetition.description).")
                                Text(task.remindTime != nil ? "Remind at: \(dateFormatter(dateFormat: .timeWithPeriods).string(from: task.remindTime ?? Date()))" : "No reminder")
                            }
                        }
                        .padding(.top)
                        .padding(.horizontal)
                    }
                    .padding(.horizontal, -16)
                    .scrollIndicators(.never)
                }

                ConfirmButton(
                    title: "Edit Task",
                    role: .confirm) {
                        
                    }
                    .padding(.bottom)
            }
            .padding()
        }
    }
}

#Preview {
    TaskDetailView(task: toDoMocks.first!)
}
