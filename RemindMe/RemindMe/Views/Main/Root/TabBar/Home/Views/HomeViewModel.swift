//
//  HomeViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 23/06/2024.
//

import CoreInterface
import DependencyInjection
import Design
import SwiftUI
import Utilities
import ToDoInterface

let toDoMocks: [ToDo] = [
    .init(name: "test1", symbol: .clipboardIcon,  image: nil, executedDate: .now, executedTime: .now, remindTime: .now, reminderRepetition: .daily, tag: .all, subtasks: [.init(title: "test", isCompleted: false), .init(title: "test2"), .init(title: "test3")]),
    .init(name: "test2", symbol: .clipboardIcon,  image: Data(), executedDate: .now, executedTime: .now, remindTime: .now, reminderRepetition: .daily, tag: .medicalCheck, subtasks: []),
    .init(name: "test3", symbol: .clipboardIcon, image: Data(), executedDate: .now, executedTime: .now, remindTime: .now, reminderRepetition: .daily, tag: .birthday, subtasks: [])
]

enum HomeError: Error, LocalizedError {
    case error1
    case error2
    
    var errorDescription: String? {
        switch self {
        case .error1:
            "dupa jasia"
        case .error2:
            "zupa jasia"
        }
    }
}

@MainActor
final class HomeViewModel: ObservableObject {
    enum State: Equatable {
        case idle
        case loading
        case loaded
        case error(String)
    }
    
    @Published private(set) var state: State = .idle
    @Published private(set) var currentDate: Date = .init()
    @Published private(set) var weekSlider: [[Date.WeekDay]] = []
    @Published private(set) var createWeek: Bool = false
    @Published private(set) var isDone: Bool = false
    @Published private(set) var tasks: [ToDo] = []
    @Published var selectedCategory: ToDoInterface.Tag = .all
    @Published var currentWeekIndex: Int = 1
    @Published var doneTaskPercentage: Double = 0.0
    @Published var categorizedCounts: [String: CategoryInfo] = ["Done your tasks": .init(count: 1, color: Colors.color)]
    @Published var isAddTaskViewPresented: Bool = false
    @Published var isDetailViewPresented: Bool = false
    @Published var selectedTaskIndex: Int? = nil
    @Inject private var toDoManager: ToDoManagerInterface
    
    var selectedTask: ToDo? {
        guard let index = selectedTaskIndex, index < tasks.count else { return nil }
        return tasks[index]
    }

    var filteredTasks: [ToDo] {
        tasks.filter { selectedCategory == .all  || $0.tag == selectedCategory }
    }
    
    var tasksByCategoryCounts: [ToDoInterface.Tag: Int] {
        var counts: [ToDoInterface.Tag: Int] = [:]

        for category in ToDoInterface.Tag.allCases {
            if category == .all {
                counts[category] = tasks.count
            } else {
                counts[category] = tasks.filter { $0.tag == category }.count
            }
        }
        return counts
    }
    
    init() {
        fetchUpdatedToDo()
        
        fetchNewCreateTasks()
        
        calculateDoneTaskPercentage()
        
        calculateCategorizedCounts()
    }
    
    func presentDetailViewButtonPressed(index: Int) {
        selectedTaskIndex = index
        
        withAnimation {
            isDetailViewPresented.toggle()
        }
    }

    func presentAddTaskViewButtonPressed() {
        withAnimation {
            isAddTaskViewPresented.toggle()
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
            .updatedTask
            .receive(on: DispatchQueue.main)
            .map { updatedToDo in
                var currentList = self.tasks
                guard let updatedToDo = updatedToDo else { return currentList }
                if let index = currentList.firstIndex(where: { $0.id == updatedToDo.id }) {
                    currentList[index] = updatedToDo
                }
                
                return currentList
            }
            .assign(to: &$tasks)
    }
    
    private func fetchNewCreateTasks() {
        toDoManager
            .updatedTasks
            .receive(on: DispatchQueue.main)
            .assign(to: &$tasks)
    }
    
    private func calculateDoneTaskPercentage() {
        toDoManager
            .updatedDoneTaskPercentage
            .receive(on: DispatchQueue.main)
            .assign(to: &$doneTaskPercentage)
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
}

//MARK: Functions to service task
extension HomeViewModel {
    func fetchFilteredTasks() async throws {
        guard state == .idle else { return }
        
        state = .loading

        do {
//                self.tasks = toDoMocks
            self.tasks = try await toDoManager.readAllToDos()
            
            state = .loaded
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}


