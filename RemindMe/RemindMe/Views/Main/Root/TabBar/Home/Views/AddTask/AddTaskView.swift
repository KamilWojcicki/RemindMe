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
        VStack(spacing: 0) {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                CustomProgressView(message: "Loading...")
            case .loaded:
                buildReadableScrollViewContent
            case .error(let error):
                Label(error.description, systemImage: "xmark.circle")
                    .background(Color.red)
            }
            
            bottomSpaceWithButton
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
                        viewModel.trigger(.handleAlertToggle)
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
    private var picker: some View {
        VStack(spacing: 30) {
            switch viewModel.selectedPicker {
            case .title:
                Picker(
                    variant: .titleAndImage(textFieldText: $viewModel.newTaskTitle, selectedIcon: $viewModel.newTaskSymbol)
                )
            case .date:
                Picker(
                    variant: .time(
                        selection: $viewModel.selectedDate,
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
                            get: {
                                viewModel.remindTime.date ?? Date()
                            },
                            set: { newDate in
                                viewModel.remindTime
                                    .setDate(newDate)
                            }),
                        dateComponents: .hourAndMinute
                    )
                )
            case .repetition:
                Picker(variant: .repetition(selectedRepetition: $viewModel.repetition))
            case .tag:
                Picker(variant: .tag(selectedTag: $viewModel.tag))
            case .subtask:
                VStack { }
            case .none:
                EmptyView()
            }
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
                        viewModel.trigger(.onShowOptionToggle)
                    } else {
                        viewModel.trigger(.createToDo)
                        dismiss()
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .background(Colors.ghostWhite)
            }
        }
    }
    
    private var buildReadableScrollViewContent: some View {
        VStack(spacing: 0) {
            ZStack {
                Symbols.chevronBackward
                    .padding()
                    .onTapGesture {
                        dismiss()
                        print("dismiss")
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
                        viewModel.trigger(.handlePickerSelection(.title))
                    }
                    
                    Row(
                        text: "\(viewModel.taskDay.description)",
                        variant: .plainText(
                            symbol: Symbols.calendar
                        )
                    ) {
                        viewModel.trigger(.handlePickerSelection(.date))
                    }
                    
                    Row(
                        text: "Time: \(dateFormatter(dateFormat: .time).string(from: viewModel.taskTime))",
                        variant: .plainText(
                            symbol: Symbols.stopwatchFill
                        )
                    ) {
                        viewModel.trigger(.handlePickerSelection(.time))
                    }
                    
                    Row(
                        text: "\(viewModel.remindTime.description)",
                        variant: .plainText(
                            symbol: Symbols.clockBadgeExclamationmarkFill
                        )
                    ) {
                        viewModel.trigger(.handlePickerSelection(.reminder))
                    }
                    
                    Row(
                        text: "\(viewModel.repetition.description)",
                        variant: .plainText(
                            symbol: Symbols.clockArrowCirclepath
                        )
                    ) {
                        viewModel.trigger(.handlePickerSelection(.repetition))
                    }
                    
                    Row(
                        text: "\(viewModel.tag.rawValue)",
                        variant: .plainText(
                            symbol: Symbols.tagFill
                        )
                    ) {
                        viewModel.trigger(.handlePickerSelection(.tag))
                    }
                    
                    Row(
                        text: "Subtask",
                        variant: .subtask(
                            symbol: Symbols.plus
                        )
                    ) {
                        viewModel.trigger(.handleAlertToggle)
                        #warning("This function is not implemented yet")
                        //viewModel.trigger(.handlePickerSelection(.subtask))
                    }
                    
                    PhotoAttacher(defaultScrollAnchor: $viewModel.defaultScrollAnchor, photoPickerSelection: $viewModel.taskImageSelection)
                }
                .padding()
            }, onScroll: { position in
                viewModel.trigger(.onScrollDividerAction(position))
                viewModel.trigger(.onScrolledHeaderAction(position))
            })
            .scrollIndicators(.hidden)
            .defaultScrollAnchor(viewModel.defaultScrollAnchor)
            .disabled(viewModel.isPickerSelected.wrappedValue)
        }
        
    }
}
