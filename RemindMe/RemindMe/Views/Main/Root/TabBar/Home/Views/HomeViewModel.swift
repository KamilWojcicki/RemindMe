//
//  HomeViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 23/06/2024.
//

import Combine
import CoreInterface
import DependencyInjection
import Design
import SwiftUI
import Utilities
import ToDoInterface

let toDoMocks: [ToDo] = [
    .init(name: "test1", symbol: Icon.name(for: .birthdayIcon),  image: nil, executedDate: .now, executedTime: .now, remindTime: .now, reminderRepetition: .daily, tag: .all, subToDos: [.init(title: "test", isCompleted: false), .init(title: "test2"), .init(title: "test3")]),
    .init(name: "test2", symbol: Icon.name(for: .birthdayIcon),  image: Data(), executedDate: .now, executedTime: .now, remindTime: .now, reminderRepetition: .daily, tag: .medicalCheck, subToDos: []),
    .init(name: "test3", symbol: Icon.name(for: .birthdayIcon), image: Data(), executedDate: .now, executedTime: .now, remindTime: .now, reminderRepetition: .daily, tag: .birthday, subToDos: [])
]

@MainActor
final class HomeViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case loaded
        case error(String)
    }
    
    @Published private(set) var state: State = .loading
    @Published private(set) var currentDate: Date = .init()
    @Published private(set) var weekSlider: [[Date.WeekDay]] = []
    @Published private(set) var createWeek: Bool = false
    @Published private(set) var isDone: Bool = false
    @Published private(set) var toDos: [ToDo] = []
    @Published var selectedCategory: ToDoInterface.Tag = .all
    @Published var currentWeekIndex: Int = 1
    @Published var doneToDoPercentage: Double = 0.0
    @Published var categorizedCounts: [String: CategoryInfo] = ["Done your tasks": .init(count: 1, color: Colors.color)]
    @Published var isAddToDoViewPresented: Bool = false
    @Published var isDetailViewPresented: Bool = false
    @Published var selectedToDoIndex: Int? = nil
    @Published var isErrorPresented: Bool = false
    @Inject private var toDoManager: ToDoManagerInterface
    
    private var backgroundEntryTime: Date?
    private var cancellables = Set<AnyCancellable>()
    
    var selectedToDo: ToDo? {
        guard let index = selectedToDoIndex, index < filteredToDos.count else { return nil }
        return filteredToDos[index]
    }

    var filteredToDos: [ToDo] { toDos.filter { selectedCategory == .all  || $0.tag == selectedCategory } }
    
    var tasksByCategoryCounts: [ToDoInterface.Tag: Int] {
        var counts: [ToDoInterface.Tag: Int] = [:]

        for category in ToDoInterface.Tag.allCases {
            if category == .all {
                counts[category] = toDos.count
            } else {
                counts[category] = toDos.filter { $0.tag == category }.count
            }
        }
        return counts
    }
    
    init() {
        fetchUpdatedToDo()
        
        fetchNewCreateToDos()
        
        calculateDoneToDosPercentage()
        
        calculateCategorizedCounts()
        
        observeAppLifecycle()
    }
    
    func presentDetailViewButtonPressed(index: Int) {
        selectedToDoIndex = index
        
        withAnimation {
            isDetailViewPresented.toggle()
        }
    }

    func presentAddToDoViewButtonPressed() {
        withAnimation {
            isAddToDoViewPresented.toggle()
        }
    }

    func onChangeCategoryButtonPressed(category: ToDoInterface.Tag) {
        withAnimation {
            selectedCategory = category
        }
    }
}

//MARK: Functions to service filtering
extension HomeViewModel {
    private func fetchUpdatedToDo() {
        toDoManager
            .updatedToDo
            .receive(on: DispatchQueue.main)
            .map { updatedToDo in
                var currentList = self.toDos
                guard let updatedToDo = updatedToDo else { return currentList }
                if let index = currentList.firstIndex(where: { $0.id == updatedToDo.id }) {
                    currentList[index] = updatedToDo
                }
                
                return currentList
            }
            .assign(to: &$toDos)
    }
    
    private func fetchNewCreateToDos() {
        toDoManager
            .updatedToDos
            .receive(on: DispatchQueue.main)
            .assign(to: &$toDos)
    }
    
    private func calculateDoneToDosPercentage() {
        toDoManager
            .updatedDoneToDosPercentage
            .receive(on: DispatchQueue.main)
            .assign(to: &$doneToDoPercentage)
    }
    
    private func calculateCategorizedCounts() {
        toDoManager
            .updatedCategorizedCounts
            .receive(on: DispatchQueue.main)
            .assign(to: &$categorizedCounts)
    }
}

//MARK: Functions to service dates
extension HomeViewModel {
    func fetchWeek() {
        if weekSlider.isEmpty {
            let currentWeek = Date().fetchWeek()
            
            if let firstDate = currentWeek.first?.date {
                weekSlider.append(firstDate.createPreviousWeek())
            }
            
            weekSlider.append(currentWeek)
            
            if let lastDate = currentWeek.last?.date {
                weekSlider.append(lastDate.createNextWeek())
            }
        }
    }
    
    func changeDayButtonPressed(_ day: Date) {
        withAnimation(.snappy) {
            currentDate = day
        }
    }
    
    func onPreferenceChangeOffsetAction(_ value: CGFloat) {
        if value.rounded() == 10 && createWeek {
            paginateWeek()
            createWeek = false
        }
    }
    
    private func paginateWeek() {
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
    }
    
    func onCreateWeekAction() {
        createWeek = true
    }
    
    private func observeAppLifecycle() {
            let notificationCenter = NotificationCenter.default

            notificationCenter.publisher(for: UIApplication.didEnterBackgroundNotification)
                .sink { [weak self] _ in
                    self?.backgroundEntryTime = Date()
                }
                .store(in: &cancellables)
            
            notificationCenter.publisher(for: UIApplication.willEnterForegroundNotification)
                .sink { [weak self] _ in
                    self?.handleAppDidBecomeActive()
                }
                .store(in: &cancellables)
        }

        private func handleAppDidBecomeActive() {
            guard let backgroundTime = backgroundEntryTime else { return }
            
            let elapsedTime = Date().timeIntervalSince(backgroundTime)
            if elapsedTime >= 5 * 60 {
                currentDate = Date()
            }
        }
}

//MARK: Functions to service task
extension HomeViewModel {
    func fetchToDos() async throws {
        state = .loading
//                        self.toDos = toDoMocks
        self.toDos = try await toDoManager.readAllToDos()
        
        state = .loaded
    }
}

//MARK: Errors
extension HomeViewModel {
    func handleError(error: Error) {
        withAnimation {
            if let localizedError = error as? LocalizedError {
                state = .error(localizedError.localizedDescription)
            } else {
                state = .error(AppError.unexpectedError(error.localizedDescription).errorDescription ?? error.localizedDescription)
            }
        }
    }
}
