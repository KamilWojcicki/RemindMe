//
//  AddToDoView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 10/08/2024.
//

import Components
import Design
import Navigation
import SwiftUI
import ToDoInterface
import Utilities

struct AddToDoView: View {
    @StateObject private var viewModel = AddToDoViewModel()
    @Environment(\.dismiss) private var dismiss
    @Binding var isEditing: Bool?
    
    init(selectedToDo: ToDo? = nil, isEditing: Binding<Bool?> = .constant(nil)) {
        self._viewModel = StateObject(wrappedValue: AddToDoViewModel(toDoToEdit: selectedToDo))
        self._isEditing = isEditing
    }
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                CustomProgressView(message: "Loading...")
            case .loaded:
                buildAddTaskView
            case .error:
                buildAddTaskView //background
            }

            if case .error(let error) = viewModel.state {
                CustomErrorView(message: error) {
                    viewModel.handleDismissErrorView()
                }
                .transition(.opacity)
            }
        }
        .navigationBarBackButtonHidden()
        .background(Colors.ghostWhite)
    }
}

#Preview {
    AddToDoView()
}

extension AddToDoView {
    @ViewBuilder
    private var picker: some View {
        switch viewModel.selectedPicker {
        case .title:
            viewModel.createPicker(
                variant: .titleAndImage(
                    textFieldText: $viewModel.newToDoTitle,
                    selectedIcon: $viewModel.newToDoSymbol
                ),
                title: "Change Image"
            )
        case .date:
            viewModel.createPicker(
                variant: .time(
                    selection: $viewModel.toDoDay,
                    dateComponents: .date
                ),
                title: "Choose a date"
            )
        case .time:
            viewModel.createPicker(
                variant: .time(
                    selection: $viewModel.toDoTime,
                    dateComponents: .hourAndMinute
                ),
                title: "Choose a time"
            )
        case .reminder:
            viewModel.createPicker(
                variant: .time(
                    selection: Binding(
                        get: { viewModel.remindTime ?? Date() },
                        set: { viewModel.remindTime = $0 }
                    ),
                    dateComponents: .hourAndMinute
                ),
                title: "Choose a reminder time"
            )
        case .repetition:
            viewModel.createPicker(
                variant: .repetition(selectedRepetition: $viewModel.repetition),
                title: "Choose a repetition"
            )
        case .tag:
            viewModel.createPicker(
                variant: .tag(selectedTag: $viewModel.tag),
                title: "Choose a tag"
            )
        case .subToDo:
            viewModel.createPicker(
                variant: .subToDo(textFieldText: $viewModel.newSubToDoTitle),
                title: "New SubToDo"
            )
        case .editSubToDo:
            viewModel.createPicker(
                variant: .subToDo(textFieldText: $viewModel.editSubToDoTitle),
                title: "Edit SubToDo"
            )
        case .none:
            EmptyView()
        }
    }
    
    private var bottomSpaceWithButton: some View {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    if viewModel.showDivider {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Colors.night.opacity(0.1))
                            .frame(height: 2)
                            .frame(maxWidth: .infinity)
                    }
                    
                    if viewModel.isPickerSelected.wrappedValue {
                        picker
                            .transition(.asymmetric(insertion: .push(from: .bottom), removal: .identity))
                    }
                }
                .keyboardSpace()
                
                ConfirmButton(title: viewModel.isPickerSelected.wrappedValue ? "Confirm" : viewModel.buttonTitle, role: .confirm) {
                    if viewModel.isPickerSelected.wrappedValue {
                        do {
                            try viewModel.onPickerSelected(picker: viewModel.selectedPicker)
                        } catch {
                            viewModel.handleError(error: error)
                        }
                       
                    } else {
                        Task {
                            do {
                                if viewModel.selectedToDo != nil {
                                    try await viewModel.updateToDo()
                                    isEditing?.toggle()
                                } else {
                                    try await viewModel.createToDo()
                                    dismiss()
                                }
                            } catch {
                                viewModel.handleError(error: error)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .padding(.bottom, 30)
                .background(Colors.ghostWhite)
                .trackGeometry(position: $viewModel.bottomSpacePosition)
            }
    }
    
    private var buildAddTaskView: some View {
        VStack(spacing: 0) {
            buildReadableScrollViewContent
            
            bottomSpaceWithButton
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    private var buildReadableScrollViewContent: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                if isEditing != nil {
                    Grabber()
                }
                
                ZStack {
                    Symbols.chevronBackward
                        .padding()
                        .onTapGesture {
                            viewModel.onBackButtonTap(isEditing: $isEditing, dismiss: dismiss)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .tint(Colors.night)
                    
                    Text(viewModel.bannerTitle)
                }
            }
            .font(.size18Default)
            .frame(maxWidth: .infinity)
            .background(viewModel.isScrolled ? Colors.night.opacity(0.08) : .clear)
            .animation(.smooth, value: viewModel.isScrolled)
            
            ReadableScrollView(content: {
                VStack(spacing: 15) {
                    Row(
                        text: viewModel.newToDoTitle,
                        variant: .title(
                            icon: viewModel.newToDoSymbol,
                            instruction: "Tap to rename and change the image"
                        )
                    ) {
                        viewModel.handlePickerSelection(.title)
                    }
                    
                    Row(
                        text: "\(viewModel.selectedDate)",
                        variant: .plainText(
                            symbol: Symbols.calendar
                        )
                    ) {
                        viewModel.handlePickerSelection(.date)
                    }
                    
                    Row(
                        text: viewModel.selectedTime,
                        variant: .plainText(
                            symbol: Symbols.stopwatchFill
                        )
                    ) {
                        viewModel.handlePickerSelection(.time)
                    }
                    
                    Row(
                        text: "\(viewModel.selectedReminder)",
                        variant: .plainText(
                            symbol: Symbols.clockBadgeExclamationmarkFill
                        )
                    ) {
                        viewModel.handlePickerSelection(.reminder)
                    }
                    
                    Row(
                        text: "\(viewModel.repetition.description)",
                        variant: .plainText(
                            symbol: Symbols.clockArrowCirclepath
                        )
                    ) {
                        viewModel.handlePickerSelection(.repetition)
                    }
                    
                    Row(
                        text: "\(viewModel.tag.rawValue)",
                        variant: .plainText(
                            symbol: Symbols.tagFill
                        )
                    ) {
                        viewModel.handlePickerSelection(.tag)
                    }
                    
                    buildSubtasksRows
                    
                    Row(
                        text: "SubToDo",
                        variant: .subToDo(
                            symbol: Symbols.plus
                        )
                    ) {
                        viewModel.handlePickerSelection(.subToDo)
                    }
                    
                    PhotoAttacher(defaultScrollAnchor: $viewModel.defaultScrollAnchor, photoAttacherHeight: $viewModel.photoAttacherHeight, photoPickerSelection: $viewModel.toDoImageSelection)
                }
                .padding()
            }, onScroll: { position in
                viewModel.handleScrollActions(position: position)
            })
            .defaultScrollAnchor(viewModel.defaultScrollAnchor)
            .disabled(viewModel.isPickerSelected.wrappedValue)
        }
    }
    
    @ViewBuilder
    private var buildSubtasksRows: some View {
        if !viewModel.selectedToDoList.isEmpty {
            ForEach(viewModel.selectedToDoList.indices, id: \.self) { subToDoIndex in
                let subToDo = viewModel.selectedToDoList[subToDoIndex]
                Row(text: subToDo.title, variant: .plainText(symbol: nil)) {
                    viewModel.handlePickerSelection(.editSubToDo, subtaskIndex: subToDoIndex)
                }
            }
        }
    }
}
