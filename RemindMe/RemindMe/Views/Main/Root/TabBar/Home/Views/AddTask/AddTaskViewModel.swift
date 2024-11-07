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
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    @Published private(set) var state: State = .idle
    @Published private(set) var showDivider: Bool = true
    @Published private(set) var selectedPicker: Picker?
    @Published private(set) var selectedTaskImage: UIImage? = nil
    @Published var taskImageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: taskImageSelection)
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
    @Published var subtasks: [SubToDo] = []
    @Published var defaultScrollAnchor: UnitPoint? = .top
    @Published var alertToggle: Bool = false
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
    
    init() {
        self.state = .loaded
    }
    
    func handleScrollActions(position: Double) {
        showDivider = position >= -80.0
        isScrolled = position < -10
    }
    
     func onPickerSelected(picker: Picker?) {
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
    
    func handlePickerSelection(_ picker: Picker) {
        withAnimation(.smooth(duration: 0.7)) {
            selectedPicker = picker
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
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            do {
                let data = try await selection.loadTransferable(type: Data.self)
                
                guard let data, let uiImage = UIImage(data: data) else {
                    //TODO: throw custom error
                    return
                }
                
                selectedTaskImage = uiImage
            } catch {
                print(error)
            }
        }
    }
    
    func createToDo() {
        Task {
            do {
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
                
                debugPrint("success saving todo!!!!!")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func createSubtask() {
        guard !newSubtaskTitle.isEmpty else { return }
        
        let newSubtask = SubToDo(title: newSubtaskTitle)
        
        subtasks.append(newSubtask)
        
        newSubtaskTitle = ""
    }
}
