//
//  ToDoDetailView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 29/10/2024.
//

import Components
import Design
import SwiftUI
import ToDoInterface
import Utilities

struct ToDoDetailView: View {
    @StateObject private var viewModel = ToDoDetailViewModel()
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
                FullImageView(isPresented: $viewModel.showFullImage, image: toDo?.image)
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
    ToDoDetailView(toDo: toDoMocks.first!)
}

extension ToDoDetailView {
    @ViewBuilder
    private var buildWrapperForToDoDetailView: some View {
        if viewModel.isEditing {
            if let toDo = toDo {
                AddToDoView(
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
        if let toDo = toDo {
            VStack(spacing: 0) {
                Grabber()
                
                VStack(spacing: 0) {
                    ToDoInfoCellView(toDo: toDo, backgroundColor: .clear) { error in
                        viewModel.handleError(error: error)
                    }
                    .padding(.horizontal, -16)
                    
                    ReadableScrollView {
                        VStack(spacing: 10) {
                            ForEach(toDo.list.indices, id: \.self) { index in
                                let subToDo = toDo.list[index]
                                
                                Row(
                                    text: subToDo.title,
                                    variant: .subToDoWithCheckmark(subToDo: subToDo)
                                ) {
                                    Task {
                                        do {
                                            try await viewModel.updateSubToDo(toDo: toDo,subToDo: subToDo)
                                        } catch {
                                            viewModel.handleError(error: error)
                                        }
                                    }
                                }
                            }
                            
                            Button {
                                viewModel.onImageTapAction(toDo: toDo)
                            } label: {
                                buildTappableImage(toDo: toDo)
                            }
                            
                            HStack {
                                Text("\(toDo.reminderRepetition.description).")
                                Text(toDo.remindTime != nil ? "Remind at: \(dateFormatter(dateFormat: .timeWithPeriods).string(from: toDo.remindTime ?? Date()))" : "No reminder")
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
    
    private func buildTappableImage(toDo: ToDo) -> some View {
        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: 340)
            .opacity(0)
            .overlay {
                if let uiImage = UIImage(data: toDo.image ?? Data()) {
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
