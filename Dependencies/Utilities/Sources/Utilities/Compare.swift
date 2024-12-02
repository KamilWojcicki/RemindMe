//
//  Compare.swift
//  Utilities
//
//  Created by Kamil Wójcicki on 04/11/2024.
//

import Foundation
import LocalDatabaseInterface

public func compare(old: any LocalStorable, updated: any LocalStorable) -> [String: Any] {
    var differences: [String: Any] = [:]

    let oldMirror = Mirror(reflecting: old)
    let newMirror = Mirror(reflecting: updated)

    for (propertyName, oldValue) in oldMirror.children {
        guard let propertyName else { continue }

        // Get the updated value
        if let newValue = newMirror.descendant(propertyName) {
            // Handle RawRepresentable types (e.g., enums with raw values)
            if let oldEnumValue = oldValue as? (any RawRepresentable),
               let newEnumValue = newValue as? (any RawRepresentable),
               "\(oldEnumValue.rawValue)" != "\(newEnumValue.rawValue)" {
                differences[propertyName] = newEnumValue.rawValue
            }
            // Default case: Compare values directly
            else if "\(oldValue)" != "\(newValue)" {
                differences[propertyName] = newValue
            }
        }
    }

    return differences
}

