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
    let toDo: ToDo?
    
    init(toDo: ToDo?) { self.toDo = toDo }
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loaded:
                buildWrapperForToDoDetailView
            case .error:
                buildWrapperForToDoDetailView //background
            }
            
            if case .error(let error) = viewModel.state {
                CustomErrorView(message: error) {
                    viewModel.handleDismissErrorView()
                }
                .transition(.opacity)
            }
            
            if viewModel.showFullImage {
                FullImageView(isPresented: $viewModel.showFullImage, image: task?.image)
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                viewModel.handleScrollActions()
            }
        }
    }
}

#Preview {
    TaskDetailView(task: toDoMocks.first!)
}

extension TaskDetailView {
    @ViewBuilder
    private var buildWrapperForToDoDetailView: some View {
        if viewModel.isEditing {
            if let toDo = task {
                AddTaskView(
                    selectedToDo: toDo,
                    isEditing: Binding<Bool?>(
                        get: { viewModel.isEditing },
                        set: { viewModel.isEditing = $0 ?? false }
                    )
                )
                .zIndex(1)
                .transition(.move(edge: .trailing))
            }
        } else {
            buildTaskDetailView
        }
    }
    
    @ViewBuilder
    private var buildTaskDetailView: some View {
        if let task = task {
            VStack(spacing: 0) {
                Grabber()
                
                VStack(spacing: 0) {
                    TaskInfoCellView(task: task, backgroundColor: .clear) { error in
                        viewModel.handleError(error: error)
                    }
                    .padding(.horizontal, -16)
                    
                    ReadableScrollView {
                        VStack(spacing: 10) {
                            ForEach(task.list.indices, id: \.self) { index in
                                let subtask = task.list[index]
                                
                                Row(
                                    text: subtask.title,
                                    variant: .subtaskWithCheckmark(subtask: subtask)
                                ) {
                                    Task {
                                        do {
                                            try await viewModel.updateSubtask(task: task,subtask: subtask)
                                        } catch {
                                            viewModel.handleError(error: error)
                                        }
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
                            .padding(.bottom)
                            .trackGeometry(position: $viewModel.contentPosition)
                        }
                        .padding(.top)
                        .padding(.horizontal)
                        
                    } onScroll: { _ in
                        viewModel.handleScrollActions()
                    }
                    .padding(.horizontal, -16)
                }
                .padding()
                .padding(.bottom, -16)
                
                VStack(spacing: 0) {
                    if viewModel.showDivider {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Colors.night.opacity(0.1))
                            .frame(height: 2)
                            .frame(maxWidth: .infinity)
                    }
                    
                    ConfirmButton(
                        title: "Edit Task",
                        role: .confirm) {
                            viewModel.onEditToDoButtonTap()
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                        .trackGeometry(position: $viewModel.buttonPosition)
                }
            }
            .blur(radius: viewModel.showFullImage ? 10.0 : 0.0)
            .disabled(viewModel.showFullImage)
            .animation(.default, value: viewModel.showFullImage)
        }
    }
    
    private func buildTappableImage(task: ToDo) -> some View {
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
