//
//  ToDoDetailViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 30/10/2024.
//

import DependencyInjection
import Foundation
import SwiftUI
import ToDoInterface
import Utilities

@MainActor
final class ToDoDetailViewModel: ObservableObject {
    enum State: Equatable {
        case loaded
        case error(String)
    }
    
    @Published var state: State = .loaded
    @Published var showFullImage: Bool = false
    @Published var isErrorPresented: Bool = false
    @Published var isEditing: Bool = false
    @Published private(set) var showDivider: Bool = false
    @Published var contentPosition: CGFloat = 0
    @Published var buttonPosition: CGFloat = 0
    @Inject private var toDoManager: ToDoManagerInterface
    
    func updateSubToDo(toDo: ToDo, subToDo: SubToDo) async throws {
        var updatedSubToDo = subToDo
        updatedSubToDo.isCompleted.toggle()
        let updates = compare(old: subToDo, updated: updatedSubToDo)

        try await toDoManager.updateSubToDo(toDo: toDo, subToDo: subToDo, data: updates)
        
        state = .loaded
    }
}

//Errors
extension ToDoDetailViewModel {
    func handleError(error: Error) {
        withAnimation {
            if let localizedError = error as? LocalizedError {
                state = .error(localizedError.localizedDescription)
            } else {
                state = .error(AppError.unexpectedError(error.localizedDescription).errorDescription ?? error.localizedDescription)
            }
        }
    }
    
    func handleDismissErrorView() {
        withAnimation {
            state = .loaded
        }
    }
}

extension ToDoDetailViewModel {
    func onImageTapAction(toDo: ToDo) {
        withAnimation {
            guard toDo.image != nil else { return }
            showFullImage.toggle()
        }
    }
    
    func onEditToDoButtonTap() {
        withAnimation {
            isEditing.toggle()
        }
    }
    
    func handleScrollActions() {
        showDivider = contentPosition + 30 >= buttonPosition
    }
}
