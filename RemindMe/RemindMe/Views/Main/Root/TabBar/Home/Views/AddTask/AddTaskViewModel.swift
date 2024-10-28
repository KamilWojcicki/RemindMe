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
final class AddTaskViewModel: ViewModelInterface {
    enum State: Equatable {
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    enum Event {
        case onScrollDividerAction(Double)
        case onScrolledHeaderAction(Double)
        case onShowOptionToggle
        case handlePickerSelection(Picker)
        case handleAlertToggle
        case createToDo
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
    @Published private(set) var taskDay: Day = .today
    @Published var taskTime: Date = .now
    @Published var remindTime: Reminder = .noReminder
    @Published var repetition: Repetition = .noRepeat
    @Published var tag: Tag = .all
    @Published var defaultScrollAnchor: UnitPoint? = .top
    @Published var alertToggle: Bool = false
    @Inject private var toDoManager: ToDoManagerInterface
    
    var isPickerSelected: Binding<Bool> {
        Binding<Bool>(
            get: {
                self.selectedPicker != nil },  // Return true if a picker is selected
            set: {
                if !$0 {
                    self.selectedPicker = nil   // Set to nil if dismissed
                }
            }
        )
    }
    
    var selectedDate: Date {
        get {
            switch taskDay {
            case .today:
                return Date()
            case .otherDay(let date):
                return date
            }
        }
        set {
            if Calendar.current.isDateInToday(newValue) {
                taskDay = .today
            } else {
                taskDay = .otherDay(newValue)
            }
        }
    }
    
    init() {
        self.state = .loaded
    }
    
    func trigger(_ event: Event) {
        switch event {
        case .onScrollDividerAction(let position):
            onScrollDividerAction(position: position)
        case .onScrolledHeaderAction(let position):
            onScrolledHeaderAction(position: position)
        case .onShowOptionToggle:
            onShowOptionToggle()
        case .handlePickerSelection(let picker):
            handlePickerSelection(picker: picker)
        case .handleAlertToggle:
            handleAlertToggle()
        case .createToDo:
            createToDo()
        }
    }
    
    private func onScrollDividerAction(position: Double) {
        showDivider = position < -80.0 ? false : true
    }
    
    private func onScrolledHeaderAction(position: Double) {
        isScrolled = position < -10
    }
    
    private func onShowOptionToggle() {
        withAnimation(.smooth(duration: 0.1)) {
            selectedPicker = nil
        }
    }
    
    private func handlePickerSelection(picker: Picker) {
        withAnimation(.smooth(duration: 0.7)) {
            selectedPicker = picker
        }
    }
    
    private func handleAlertToggle() {
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
    
    private func createToDo() {
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
                    tag: tag
                )
                
                try await toDoManager.createToDo(todo: newToDo)
                
                debugPrint("success saving todo!!!!!")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
