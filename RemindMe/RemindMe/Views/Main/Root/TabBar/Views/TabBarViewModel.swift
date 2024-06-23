//
//  TabBarViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import DependencyInjection
import Foundation
import Navigation
import SwiftUI
import ToDoInterface

enum Action {
    case create
    case edit
}

@MainActor
final class TabBarViewModel: ObservableObject {
    @Published private(set) var tabs: [Tab] = [.home, .history, .tasks, .settings]
    @Published var selectedTab: String?
    @Published var action: Action = .create
    @Published private(set) var category: ToDoInterface.Category?
    @Inject private var toDoManager: ToDoManagerInterface
    
    init() {
        self.selectedTab = "Home"
        fetchCategory()
    }
    
    private func fetchCategory() {
        toDoManager
            .updatedCategory
            .receive(on: DispatchQueue.main)
            .assign(to: &$category)
    }
    
    
    
    func tapped(tab: String) {
        withAnimation {
            self.selectedTab = tab
        }
    }
}
