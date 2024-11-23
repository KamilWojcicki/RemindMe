//
//  AddTaskViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 17/08/2024.
//

import Components
import CoreInterface
import DependencyInjection
import Design
import Foundation
import PhotosUI
import SwiftUI
import ToDoInterface
import Utilities

@MainActor
final class AddTaskViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded
        case error(String)
    }
    @Environment(\.dismiss) private var dismiss
    @Published var state: State = .loaded
    @Published private(set) var showDivider: Bool = true
    @Published private(set) var selectedPicker: Picker?
    @Published private(set) var selectedTaskImage: UIImage? = nil
    @Published var taskImageSelection: PhotosPickerItem? = nil {
        didSet {
            Task {
                do {
                    try await setImage(from: taskImageSelection)
                } catch {
                    handleError(error: error)
                }
            }
        }
    }
    //TODO: add validation to newTaskTitle
    @Published var newTaskTitle: String = ""
    @Published var isScrolled: Bool = false
    @Published var newTaskSymbol: Icon = .clipboardIcon
    @Published var taskDay: Date = .now
    @Published var taskTime: Date = .now
    @Published var remindTime: Date?
    @Published var repetition: Repetition = .noRepeat
    @Published var tag: Tag = .all
    @Published var newSubtaskTitle: String = ""
    @Published var editSubtaskTextFieldText: String = ""
    @Published var editingSubtaskIndex: Int? = nil
    @Published var subtasks: [SubToDo] = []
    @Published var defaultScrollAnchor: UnitPoint? = .top
    @Published var alertToggle: Bool = false
    @Published var isErrorPresented: Bool = true
   
    @Inject private var toDoManager: ToDoManagerInterface
    
    var isPickerSelected: Binding<Bool> {
        Binding<Bool>(
            get: {
                self.selectedPicker != nil },
            set: {
                if !$0 {
                    self.selectedPicker = nil
                }
            }
        )
    }
    
    var selectedDate: String { taskDay.isToday ? "Today" : dateFormatter(dateFormat: .dateWithDots).string(from: taskDay) }
    
    var selectedTime: String { "Time: \(dateFormatter(dateFormat: .time).string(from: taskTime))" }
    
    var selectedReminder: String { remindTime != nil ? dateFormatter(dateFormat: .timeWithPeriods).string(from: remindTime ?? Date()) : "No reminder" }
    
    func handleScrollActions(position: Double) {
        showDivider = position >= -80.0
        isScrolled = position < -10
    }
    
     func onPickerSelected(picker: Picker?) {
         if let index = editingSubtaskIndex, selectedPicker == .editSubtask {
             subtasks[index].title = editSubtaskTextFieldText
         }
         
         if picker == .subtask {
            createSubtask()
        }
        
        onShowOptionToggle()
    }
    
    private func onShowOptionToggle() {
        withAnimation(.smooth(duration: 0.1)) {
            selectedPicker = nil
        }
    }
    
    func handlePickerSelection(_ picker: Picker, subtaskIndex: Int? = nil) {
        withAnimation(.smooth(duration: 0.7)) {
            selectedPicker = picker
            
            if let index = subtaskIndex {
                editingSubtaskIndex = index
                editSubtaskTextFieldText = subtasks[index].title
            }
        }
    }
    
    func handleAlertToggle() {
        withAnimation {
            alertToggle.toggle()
        }
    }
    
    typealias Picker = ToDoInterface.Picker
}

extension AddTaskViewModel {
    private func setImage(from selection: PhotosPickerItem?) async throws {
        guard let selection else { return }
        
        let data = try await selection.loadTransferable(type: Data.self)
        
        guard let data, let uiImage = UIImage(data: data) else {
            throw AppError.unableToLoadImage
        }
        
        selectedTaskImage = uiImage
    }
    
    func createToDo() async throws {
        state = .loading
        
        let newToDo = ToDo(
            name: newTaskTitle,
            symbol: newTaskSymbol,
            image: selectedTaskImage?.jpegData(compressionQuality: 0.9),
            executedDate: taskDay,
            executedTime: taskTime,
            remindTime: remindTime,
            reminderRepetition: repetition,
            tag: tag,
            subtasks: subtasks
        )
        
        try await toDoManager.createToDo(todo: newToDo)
        
        state = .loaded
    }
    
    func handleError(error: Error) {
        withAnimation {
            if let localizedError = error as? LocalizedError {
                state = .error(localizedError.localizedDescription)
            } else {
                state = .error(AppError.unexpectedError(error.localizedDescription).errorDescription ?? error.localizedDescription)
            }
        }
    }
    
    func handleDismissErrorView() {
        withAnimation {
            state = .loaded
        }
    }
    
    private func createSubtask() {
        guard !newSubtaskTitle.isEmpty else { return }
        
        let newSubtask = SubToDo(title: newSubtaskTitle)
        
        subtasks.append(newSubtask)
        
        newSubtaskTitle = ""
    }
}
