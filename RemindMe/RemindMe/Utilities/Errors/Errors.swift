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
    case unableToUpdateSubToDo
    case unableToUpdateToDo
    case unableToCreateEmptyTitle
    case unexpectedError(String)
    
    var errorDescription: String? {
        switch self {
        case .unableToFetchToDos:
            return "Unable to fetch ToDo's"
        case .unableToCreateToDo:
            return "Unable to create ToDo"
        case .unableToLoadImage:
            return "Unable to load image"
        case .unableToUpdateSubToDo:
            return "Unable to update SubToDo"
        case .unableToUpdateToDo:
            return "Unable to update ToDo"
        case .unableToCreateEmptyTitle:
            return "Title cannot be empty!"
        case .unexpectedError(let error):
            return "Unexpected error occured: \(error)"
        }
    }
}
