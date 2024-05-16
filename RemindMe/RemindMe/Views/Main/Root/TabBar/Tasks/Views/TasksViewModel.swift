//
//  TasksViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import Foundation
import ToDoInterface

final class TasksViewModel: ObservableObject {
    @Published var tasks: [ToDo] = []
    @Published var isSheetPresented: Bool = false
    
    func withSheetPreseted() {
        isSheetPresented.toggle()
    }
}
