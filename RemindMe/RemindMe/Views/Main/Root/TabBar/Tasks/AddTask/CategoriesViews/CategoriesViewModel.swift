//
//  CategoriesViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 22/05/2024.
//

import Foundation

enum Period: String, CaseIterable {
    case onceAnHour = "Once an hour"
    case onceADay = "Once a day"
    case onceAWeek = "Once a week"
    case onceAMonth = "Once a month"
    case onceAYear = "Once a year"
    case custom = "Custom"
}

final class CategoriesViewModel: ObservableObject {
    @Published var isOn: Bool = false
    @Published var period: Period = .onceADay
}
