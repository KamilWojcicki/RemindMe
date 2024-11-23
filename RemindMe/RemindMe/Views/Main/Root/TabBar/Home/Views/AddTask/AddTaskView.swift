//
//  AddTaskView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 10/08/2024.
//

import Components
import Design
import Navigation
import SwiftUI
import Utilities

struct AddTaskView: View {
    @StateObject private var viewModel = AddTaskViewModel()
    @Environment(\.dismiss) private var dismiss
    
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
        .withAlert(
            errorTitle: "Warning",
            message: "This function isn't available yet.",
            errorToggle: $viewModel.alertToggle,
            buttons: [
                .submit(
                    title: "Ok",
                    action: {
                        viewModel.handleAlertToggle()
                    }
                )
            ]
        )
    }
}

#Preview {
    AddTaskView()
}

extension AddTaskView {
    @ViewBuilder
    private var picker: some View {
        switch viewModel.selectedPicker {
        case .title:
            Picker(
                variant: .titleAndImage(
                    textFieldText: $viewModel.newTaskTitle,
                    selectedIcon: $viewModel.newTaskSymbol
                )
            )
        case .date:
            Picker(
                variant: .time(
                    selection: $viewModel.taskDay,
                    dateComponents: .date
                )
            )
        case .time:
            Picker(
                variant: .time(
                    selection: $viewModel.taskTime,
                    dateComponents: .hourAndMinute
                )
            )
        case .reminder:
            Picker(
                variant: .time(
                    selection: Binding(
                        get: { viewModel.remindTime ?? Date() },
                        set: { viewModel.remindTime = $0 }
                    ),
                    dateComponents: .hourAndMinute
                )
            )
        case .repetition:
            Picker(variant: .repetition(selectedRepetition: $viewModel.repetition))
        case .tag:
            Picker(variant: .tag(selectedTag: $viewModel.tag))
        case .subtask:
            Picker(variant: .subtask(textFieldText: $viewModel.newSubtaskTitle))
        case .editSubtask:
            Picker(variant: .subtask(textFieldText: $viewModel.editSubtaskTextFieldText))
        case .none:
            EmptyView()
        }
    }
    
    private var bottomSpaceWithButton: some View {
        ZStack {
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
                
                ConfirmButton(title: viewModel.isPickerSelected.wrappedValue ? "Confirm" : "Create Task", role: .confirm) {
                    if viewModel.isPickerSelected.wrappedValue {
                        viewModel.onPickerSelected(picker: viewModel.selectedPicker)
                    } else {
                        Task {
                            do {
                                try await viewModel.createToDo()
                                dismiss()
                            } catch {
                                viewModel.handleError(error: error)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .background(Colors.ghostWhite)
            }
        }
    }
    
    private var buildAddTaskView: some View {
        VStack(spacing: 0) {
            buildReadableScrollViewContent
            
            bottomSpaceWithButton
        }
    }
    
    private var buildReadableScrollViewContent: some View {
        VStack(spacing: 0) {
            ZStack {
                Symbols.chevronBackward
                    .padding()
                    .onTapGesture {
                        dismiss()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .tint(Colors.night)
                
                Text("New Task")
            }
            .font(.size18Default)
            .frame(maxWidth: .infinity)
            .background(viewModel.isScrolled ? Colors.night.opacity(0.08) : .clear)
            .animation(.smooth, value: viewModel.isScrolled)
            
            ReadableScrollView(content: {
                VStack(spacing: 15) {
                    Row(
                        text: viewModel.newTaskTitle,
                        variant: .title(
                            icon: viewModel.newTaskSymbol,
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
                        text: "Subtask",
                        variant: .subtask(
                            symbol: Symbols.plus
                        )
                    ) {
                        viewModel.handlePickerSelection(.subtask)
                    }
                    
                    PhotoAttacher(defaultScrollAnchor: $viewModel.defaultScrollAnchor, photoPickerSelection: $viewModel.taskImageSelection)
                }
                .padding()
            }, onScroll: { position in
                viewModel.handleScrollActions(position: position)
            })
            .scrollIndicators(.hidden)
            .defaultScrollAnchor(viewModel.defaultScrollAnchor)
            .disabled(viewModel.isPickerSelected.wrappedValue)
        }
    }
    
    @ViewBuilder
    private var buildSubtasksRows: some View {
        if !viewModel.subtasks.isEmpty {
            ForEach(viewModel.subtasks.indices, id: \.self) { subtaskIndex in
                let subtask = viewModel.subtasks[subtaskIndex]
                Row(text: subtask.title, variant: .plainText(symbol: nil)) {
                    viewModel.handlePickerSelection(.editSubtask, subtaskIndex: subtaskIndex)
                }
            }
        }
    }
}
