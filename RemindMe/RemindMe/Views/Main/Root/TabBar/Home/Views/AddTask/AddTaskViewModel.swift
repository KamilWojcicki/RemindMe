//
//  AddTaskViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 17/08/2024.
//

import Components
import Design
import Foundation
import SwiftUI

enum Repetition {
    case noRepeat
    case minutely(String)
    case hourly(String)
    case daily(String, Date)
    case weekly(String)
    case monthly(String)
    case yearly(String)
    
    var description: String {
        switch self {
        case .noRepeat:
            "No repetition"
        case .minutely(let minutes):
            "Repetition every \(minutes) minutes"
        case .hourly(let hour):
            "Repetition every \(hour) hours"
        case .daily(let day, let time):
            "Repetition every \(day) at \(time)"
        case .weekly(let week):
            "Repetition every \(week)"
        case .monthly(let month):
            "Repetition every \(month)"
        case .yearly(let year):
            "Repetition every \(year)"
        }
    }
}

final class AddTaskViewModel: ObservableObject {
    @Published var newTaskTitle: String = "Title task"
    @Published var newTaskSymbol: Icon = .clipboardIcon
    @Published var taskTime: String = "7:00 PM"
    @Published var remindTime: String = "6:00 PM"
    @Published var repetition: Repetition = .noRepeat
    @Published var defaultScrollAnchor: UnitPoint? = .top
    @Published private(set) var showDivider: Bool = true
    
    func onScrollDividerAction() {
        withAnimation {
            showDivider.toggle()
        }
    }
}
