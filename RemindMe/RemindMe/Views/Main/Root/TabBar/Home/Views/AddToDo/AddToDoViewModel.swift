//
//  AddToDoViewModel.swift
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
final class AddToDoViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded
        case error(String)
    }
    @Published var state: State = .loaded
    @Published var bottomSpacePosition: CGFloat = 0
    @Published var photoAttacherHeight: CGFloat = 0
    @Published private(set) var showDivider: Bool = true
    @Published private(set) var selectedPicker: Picker?
    @Published private(set) var selectedToDoImage: UIImage? = nil
    @Published var toDoImageSelection: PhotosPickerItem? = nil {
        didSet {
            Task {
                do {
                    try await setImage(from: toDoImageSelection)
                } catch {
                    handleError(error: error)
                }
            }
        }
    }
    //TODO: add validation to newTaskTitle
    @Published var newToDoTitle: String = ""
    @Published var isScrolled: Bool = false
    @Published var newToDoSymbol: Icon = .clipboardIcon
    @Published var toDoDay: Date = .now
    @Published var toDoTime: Date = .now
    @Published var remindTime: Date?
    @Published var repetition: Repetition = .noRepeat
    @Published var tag: Tag = .all
    @Published var newSubToDoTitle: String = ""
    @Published var editSubToDoTitle: String = ""
    @Published var editingSubToDoIndex: Int? = nil
    @Published var subToDos: [SubToDo] = []
    @Published var defaultScrollAnchor: UnitPoint? = .top
    @Published var selectedToDo: ToDo?
    @Published var newSelectedToDoList: [SubToDo] = []
    @Published var selectedToDoList: [SubToDo] = []
   
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
    
    var bannerTitle: String { selectedToDo == nil ? "New Task" : selectedToDo?.name ?? "" }
    
    var buttonTitle: LocalizedStringKey { selectedToDo == nil ? "Create Task" : "Update Task" }
    
    var selectedDate: String { toDoDay.isToday ? "Today" : dateFormatter(dateFormat: .dateWithDots).string(from: toDoDay) }
    
    var selectedTime: String { "Time: \(dateFormatter(dateFormat: .time).string(from: toDoTime))" }
    
    var selectedReminder: String { remindTime != nil ? dateFormatter(dateFormat: .timeWithPeriods).string(from: remindTime ?? Date()) : "No reminder" }
    
    init(toDoToEdit: ToDo? = nil) {
        configureForEdit(toDo: toDoToEdit)
    }
    
    func handleScrollActions(position: Double) {
        showDivider = photoAttacherHeight + 120 >= bottomSpacePosition
        isScrolled = position < -10
    }
    
    func onPickerSelected(picker: Picker?) throws {
        if picker == .title {
            guard !newToDoTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                throw AppError.unableToCreateEmptyTitle
            }
        }
        
        if let index = editingSubToDoIndex, selectedPicker == .editSubToDo {
            guard !editSubToDoTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                throw AppError.unableToCreateEmptyTitle
            }
            selectedToDoList[index].title = editSubToDoTitle
        }
        
        if picker == .subToDo {
            try createSubtask()
        }
        
        onShowOptionToggle()
    }
    
    private func onShowOptionToggle() {
        withAnimation(.smooth(duration: 0.1)) {
            selectedPicker = nil
        }
    }
    
    func createPicker(variant: PickerView.Variant, title: String) -> some View {
        PickerView(variant: variant, title: title, onXmarkAction: onShowOptionToggle)
    }
    
    func handlePickerSelection(_ picker: Picker, subtaskIndex: Int? = nil) {
        withAnimation(.smooth(duration: 0.7)) {
            selectedPicker = picker
            
            if let index = subtaskIndex {
                editingSubToDoIndex = index
                editSubToDoTitle = subToDos[index].title
            }
        }
    }
    
    func onBackButtonTap(isEditing: Binding<Bool?>, dismiss: DismissAction) {
        withAnimation {
            if selectedToDo == nil {
                dismiss()
            } else {
                isEditing.wrappedValue?.toggle()
            }
        }
    }
    
    typealias Picker = ToDoInterface.Picker
}

extension AddToDoViewModel {
    private func setImage(from selection: PhotosPickerItem?) async throws {
        guard let selection else { return }
        
        let data = try await selection.loadTransferable(type: Data.self)
        
        guard let data, let uiImage = UIImage(data: data) else {
            throw AppError.unableToLoadImage
        }
        
        selectedToDoImage = uiImage
    }
    
    func createToDo() async throws {
        state = .loading
        
        let newToDo = ToDo(
            name: newToDoTitle,
            symbol: Icon.name(for: newToDoSymbol),
            image: selectedToDoImage?.jpegData(compressionQuality: 0.9),
            executedDate: toDoDay,
            executedTime: toDoTime,
            remindTime: remindTime,
            reminderRepetition: repetition,
            tag: tag,
            subToDos: subToDos
        )
        
        try await toDoManager.createToDo(toDo: newToDo)
        
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
    
    private func createSubtask() throws {
        guard !newSubToDoTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AppError.unableToCreateEmptyTitle
        }
        
        guard selectedToDo != nil else {
            let newSubtask = SubToDo(title: newSubToDoTitle)
            subToDos.append(newSubtask)
            selectedToDoList.append(newSubtask)
            newSubToDoTitle = ""
            return
        }
        
        let newSubToDo = SubToDo(title: newSubToDoTitle)
        selectedToDoList.append(newSubToDo)
        newSelectedToDoList.append(newSubToDo)
        
        newSubToDoTitle = ""
    }
}

//MARK: Updating ToDo
extension AddToDoViewModel {
    func updateToDo() async throws {
        guard let selectedToDo else { return }
        
        try await updateAllSubtasks()
        
        if !newSelectedToDoList.isEmpty {
            try await toDoManager.createSubToDo(toDo: selectedToDo, subToDos: newSelectedToDoList)
        }
        
        let updatedToDo = ToDo(
            id: selectedToDo.id,
            name: newToDoTitle,
            symbol: Icon.name(for: newToDoSymbol),
            image: selectedToDoImage?.jpegData(compressionQuality: 0.9),
            executedDate: toDoDay,
            executedTime: toDoTime,
            remindTime: remindTime,
            reminderRepetition: repetition,
            tag: tag,
            subToDos: subToDos
        )
        
        let updates = compare(old: selectedToDo, updated: updatedToDo)
        
        try await toDoManager.updateToDo(toDo: selectedToDo, data: updates)
    }
    
    private func updateAllSubtasks() async throws {
        guard let selectedToDo else { return }

        for (index, subtask) in selectedToDo.list.enumerated() {
            let updatedTitle = selectedToDoList[index].title.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !updatedTitle.isEmpty else {
                continue
            }
            
            if subtask.title != updatedTitle {
                var updatedSubToDo = subtask
                updatedSubToDo.title = updatedTitle
                let updates = compare(old: subtask, updated: updatedSubToDo)
                
                try await toDoManager.updateSubToDo(toDo: selectedToDo, subToDo: subtask, data: updates)
            }
        }
    }
}

//Initializer
extension AddToDoViewModel {
    private func configureForEdit(toDo: ToDo?) {
        guard let toDo else { return }
        
        self.selectedToDo = toDo
        self.newToDoTitle = toDo.name
        self.newToDoSymbol = Icon.icon(for: toDo.symbol)
        self.selectedToDoImage = UIImage(data: toDo.image ?? Data())
        self.toDoDay = toDo.executedDate
        self.toDoTime = toDo.executedTime
        self.remindTime = toDo.remindTime
        self.repetition = toDo.reminderRepetition
        self.tag = toDo.tag
        self.subToDos = toDo.list
        self.selectedToDoList = subToDos
    }
}
