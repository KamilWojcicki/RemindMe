//
//  Router.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 12/06/2024.
//

import Foundation
import ToDoInterface
import SwiftUI

enum Routes: Hashable {
    case addTask(task: Binding<ToDo?> = .constant(nil))
    
    static func == (lhs: Routes, rhs: Routes) -> Bool {
        switch (lhs, rhs) {
        case (.addTask, .addTask):
            return true
        }
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .addTask:
            hasher.combine("addTask")
        }
    }
}

final class Router<Path: Hashable>: ObservableObject {
    @Published var stack: [Path] = []
    
    func navigate(to destination: Path) {
        stack.append(destination)
    }
    
    func navigate(to destinations: [Path]) {
        stack += destinations
    }
    
    func navigateBack() {
        stack.removeLast()
    }
    
    func navigateBack(_ count: Int = 1) {
        guard count > 0 else { return }
        guard count <= stack.count else {
            stack = .init()
            return
        }
        stack.removeLast(count)
    }
    
    func navigateBack(to destination: Path) {
        if let index = stack.lastIndex(where: { $0 == destination }) {
            guard index < stack.count && index >= 0 else { return }
            stack = Array(stack[..<min(index + 1, stack.count)])
        }
    }
    
    func navigateToRoot() {
        stack = []
    }
    
    func replace(with destinations: [Path]) {
        stack = destinations
    }
}
