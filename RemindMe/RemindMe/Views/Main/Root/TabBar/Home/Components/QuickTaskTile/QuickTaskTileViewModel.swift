//
//  QuickTaskTileViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 15/05/2024.
//

import Foundation
import ToDoInterface

final class QuickTaskTileViewModel: ObservableObject {
    @Published var quickTaskCategories: [ToDoInterface.Category] = [.shoppingList, .birthday, .trip, .medicalCheck]
}
