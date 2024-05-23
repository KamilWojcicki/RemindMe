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
}
