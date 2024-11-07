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
    
    let oldSchedule = Mirror(reflecting: old)
    let newSchedule = Mirror(reflecting: updated)
    
    for (propertyName, value) in oldSchedule.children {
        guard let propertyName else { continue }
        
        if let newScheduleValue = newSchedule.descendant(propertyName) {
            if "\(value)" != "\(newScheduleValue)" {
                differences[propertyName] = newScheduleValue
            }
        }
    }
    return differences
}
