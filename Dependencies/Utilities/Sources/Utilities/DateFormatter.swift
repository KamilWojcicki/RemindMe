//
//  File.swift
//  
//
//  Created by Kamil Wójcicki on 23/05/2024.
//

import Foundation

public enum DateFormat: String {
    case date = "MMM dd, yyyy"
    case time = "HH:mm"
    case timeWithPeriods = "hh:mm a"
}

public func dateFormatter(dateFormat: DateFormat) -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat.rawValue
    return formatter
}
