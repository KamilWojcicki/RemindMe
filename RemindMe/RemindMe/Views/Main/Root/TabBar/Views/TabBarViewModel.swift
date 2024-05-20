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

//MARK: Create TabBarViewModel
@MainActor
final class TabBarViewModel: ObservableObject {
    @Published private(set) var tabs: [Tab] = [.home, .history, .tasks, .settings]
    @Published var selectedTab: String?
    @Published var toDoCategory: Categories? = .otherEvent
    
    init() {
        self.selectedTab = "Home"
    }
    
    func tapped(tab: String) {
        withAnimation {
            self.selectedTab = tab
        }
    }
}
