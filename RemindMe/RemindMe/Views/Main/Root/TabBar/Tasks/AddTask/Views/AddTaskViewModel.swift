//
//  AddTaskViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 18/05/2024.
//

import DependencyInjection
import Foundation
import SwiftUI
import ToDoInterface

@MainActor
final class AddTaskViewModel: ObservableObject {
    @Inject private var toDoManager: ToDoManagerInterface
    @Published var selectDate: Date = Date()
    @Published var titleTextFieldText: String = ""
    @Published var showCategories: Bool = false
    @Published var selectStartTime: Date? = Date()
    @Published var selectEndTime: Date? = Date()
    @Published var descriptionTextFieldText: String = ""
    @Published var numberOfNotifications: Int? = 1
    @Published var toDoToEdit: ToDo? = nil
    
    var category: ToDoInterface.Category? {
        didSet {
            updateCategory()
        }
    }
    
    init(category: ToDoInterface.Category?) {
        self.category = category
    }
    
    private func updateCategory() {
        toDoManager.updateCategory(newCategory: category)
    }
    
    func showCategoryPickerView() {
        showCategories.toggle()
    }
    
    func showCategoryPickerIfCategoryIsNil() {
        if category == nil {
            showCategoryPickerView()
        }
    }
    
    func nilButtonIsTapped() {
        self.category = nil
    }
    
    func addTask() {
        Task {
            do {
                guard let category = category else { return }
                let newToDo = ToDo(category: category, name: titleTextFieldText, toDoDescription: descriptionTextFieldText, executedDate: selectDate, startExecutedTime: selectStartTime, endExecutedTime: selectEndTime, numbersOfReminders: numberOfNotifications ?? 1)
                try await toDoManager.createToDo(todo: newToDo)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateTask() {
        Task {
            do {
                guard let toDoToEdit = toDoToEdit, let category = category else { return }
                
                let data: [String : Any] = [
                    ToDo.CodingKeys.id.rawValue : toDoToEdit.id,
                    ToDo.CodingKeys.name.rawValue : titleTextFieldText,
                    ToDo.CodingKeys.category.rawValue : category,
                    ToDo.CodingKeys.executedDate.rawValue : selectDate,
                    ToDo.CodingKeys.startExecutedTime.rawValue : selectStartTime ?? "",
                    ToDo.CodingKeys.endExecutedTime.rawValue : selectEndTime ?? "",
                    ToDo.CodingKeys.toDoDescription.rawValue : descriptionTextFieldText,
                    ToDo.CodingKeys.numbersOfReminders.rawValue : numberOfNotifications ?? ""
                ]
                try await toDoManager.updateToDo(data: data)
                
                
                print("todo is updated")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func readToDoToEdit(id: String) async throws {
        toDoToEdit = try await toDoManager.readToDo(primaryKey: id)
        if let toDoToEdit = toDoToEdit {
            titleTextFieldText = toDoToEdit.name
            descriptionTextFieldText = toDoToEdit.toDoDescription ?? ""
            category = toDoToEdit.category
            selectDate = toDoToEdit.executedDate
            selectStartTime = toDoToEdit.startExecutedTime
            selectEndTime = toDoToEdit.endExecutedTime
            numberOfNotifications = toDoToEdit.numbersOfReminders
        }
    }
}
