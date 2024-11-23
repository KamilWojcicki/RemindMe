//
//  Errors.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 22/11/2024.
//

import Foundation

enum AppError: LocalizedError {
    case unableToFetchToDos
    case unableToCreateToDo
    case unableToLoadImage
    case unableToUpdateSubtask
    case unableToUpdateToDo
    case unexpectedError(String)
    
    var errorDescription: String? {
        switch self {
        case .unableToFetchToDos:
            return "Unable to fetch taskss"
        case .unableToCreateToDo:
            return "Unable to create task"
        case .unableToLoadImage:
            return "Unable to load image"
        case .unableToUpdateSubtask:
            return "Unable to update subtask"
        case .unableToUpdateToDo:
            return "Unable to update task"
        case .unexpectedError(let error):
            return "Unexpected error occured: \(error)"
        }
    }
}
