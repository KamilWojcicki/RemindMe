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
        ZStack {
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
                                
                                Button {
                                    viewModel.onImageTapAction(task: task)
                                } label: {
                                    buildTappableImage(task: task)
                                }

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
                .blur(radius: viewModel.showFullImage ? 10.0 : 0.0)
                .disabled(viewModel.showFullImage)
                .animation(.default, value: viewModel.showFullImage)
            }
            
            
            if viewModel.showFullImage {
                FullImageView(isPresented: $viewModel.showFullImage, image: task?.image)
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .scale))
            }
        }
        
    }
}

#Preview {
    TaskDetailView(task: toDoMocks.first!)
}

extension TaskDetailView {
    func buildTappableImage(task: ToDo) -> some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: 340)
            .opacity(0)
            .overlay {
                if let uiImage = UIImage(data: task.image ?? Data()) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .allowsHitTesting(false)
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
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}
