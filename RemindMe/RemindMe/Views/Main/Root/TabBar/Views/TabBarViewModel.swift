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

@MainActor
final class TabBarViewModel: ObservableObject {
    @Published private(set) var tabs: [Tab] = [.home, .history, .tasks, .settings]
    @Published var selectedTab: String?
    @Published private(set) var category: ToDoInterface.Tag?
    @Inject private var toDoManager: ToDoManagerInterface
    
    init() {
        self.selectedTab = "Home"
    }
    
    func tapped(tab: String) {
        withAnimation {
            self.selectedTab = tab
        }
    }
}
