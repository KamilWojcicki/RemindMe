//
//  RoutableObject+Extension.swift
//  
//
//  Created by Kamil Wójcicki on 05/04/2024.
//

import SwiftUI
import NavigationInterface

extension RoutableObject {
    public func navigate(to destination: Destination) {
        stack.append(destination)
    }
    
    public func navigate(to destinations: [Destination]) {
        stack += destinations
    }
    
    public func navigateBack() {
        stack.removeLast()
    }
    
    public func navigateBack(_ count: Int = 1) {
        guard count > 0 else { return }
        guard count <= stack.count else {
            stack = .init()
            return
        }
        stack.removeLast(count)
    }
    

    public func navigateBack(to destination: Destination) {
        if let index = stack.lastIndex(where: { $0 == destination }) {
            guard index < stack.count && index >= 0 else { return }
            stack = Array(stack[..<min(index + 1, stack.count)])
        }
    }
    
    public func navigateToRoot() {
        stack = []
    }
    
    public func replace(with destinations: [Destination]) {
        stack = destinations
    }
}

