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
    @Published var startTimeTitle: String = ""
    @Published var endTimeTitle: String?
    @Published var description: String = ""
    @Published var selectDate: Date = Date()
    @Published var titleTextFieldText: String = ""
    @Published var showCategories: Bool = false
    @Published var selectStartTime: Date = Date()
    @Published var selectEndTime: Date = Date()
    @Published var descriptionTextFieldText: String = ""
    @Published var numberOfNotifications: Int = 1
    
    func showCategoryPickerView() {
        withAnimation {
            showCategories.toggle()
        }
    }
    
    func showCategoryPickerWhenCategoryIsNil(using secViewModel: TabBarViewModel) {
        if secViewModel.toDoCategory == nil {
            showCategoryPickerView()
        }
    }
    
    func addTask(category: Categories) {
        Task {
            do {
                let newToDo = ToDo(category: category, name: titleTextFieldText, toDoDescription: descriptionTextFieldText, executedTime: selectDate, numbersOfReminders: numberOfNotifications)
                try await toDoManager.createToDo(todo: newToDo)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
