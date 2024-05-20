//
//  HomeViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import Foundation
import ToDoInterface

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var isEdited: Bool = false
    
    func updateToDoCategory(to category: Categories, using secViewModel: TabBarViewModel) {
            secViewModel.toDoCategory = category
        }
}
