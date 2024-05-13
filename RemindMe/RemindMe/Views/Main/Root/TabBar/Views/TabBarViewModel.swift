//
//  TabBarViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import DependencyInjection
import Foundation
import SwiftUI

//MARK: Create TabBarViewModel
@MainActor
final class TabBarViewModel: ObservableObject {
    @Published private(set) var tabs: [Tab] = [.home, .history, .tasks, .settings]
    @Published var selectedTab: String?
    
    init() {
        self.selectedTab = "Home"
    }
    
    func tapped(tab: String) {
        withAnimation {
            self.selectedTab = tab
        }
    }
}
