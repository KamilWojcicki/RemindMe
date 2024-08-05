//
//  Date+Extension.swift
//
//
//  Created by Kamil Wójcicki on 23/06/2024.
//

import SwiftUI

enum DayAbbreviation {
    case PL
    case ENG
}

extension Date {
    public func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
    
    public var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    public func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let startOfWeek = weekForDate?.start else {
            return []
        }
        
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        
        return week
    }
    
    public func createNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        
        return fetchWeek(nextDate)
    }
    
    public func createPreviousWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfFirstDate = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
        
        return fetchWeek(previousDate)
    }
    
    public struct WeekDay: Identifiable {
        public var id: UUID = .init()
        public var date: Date
    }
    
    public func customDayAbbreviation() -> String {
        let dayAbbreviation: DayAbbreviation = .PL
        
        let customAbbreviationsPL = [
            "poniedziałek": "Pn",
            "wtorek": "Wt",
            "środa": "Śr",
            "czwartek": "Cz",
            "piątek": "Pt",
            "sobota": "Sb",
            "niedziela": "Nd"
        ]
        
        let customAbbreviationsENG = [
            "monday" : "Mo",
            "tuesday" : "Tu",
            "wednesday" : "We",
            "thursday" : "Th",
            "friday" : "Fr",
            "saturday" : "Sa",
            "sunday" : "Su"
        ]

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pl_PL") // Polish locale
        formatter.dateFormat = "EEEE" // Full day name

        let dayName = formatter.string(from: self)

        switch dayAbbreviation {
        case .PL:
            return customAbbreviationsPL[dayName] ?? dayName
        case .ENG:
            return customAbbreviationsENG[dayName] ?? dayName
        }
    }
}
