//
//  TabCoordinator.swift
//
//
//  Created by Kamil Wójcicki on 05/04/2024.
//

import Foundation
import NavigationInterface

final class TabCoordinator: TabCoordinatorInterface {
    private(set) var tabs: [Tab] = []
    
    private(set) var selectedTab: Tab?
    
    func register(tab: Tab) {
        self.tabs.append(tab)
        
        if tabs.count == 1 {
            select(tab)
        }
    }
    
    private func select(_ tab: Tab?) {
        guard selectedTab != tab else { return }
        selectedTab = tab
    }
}
