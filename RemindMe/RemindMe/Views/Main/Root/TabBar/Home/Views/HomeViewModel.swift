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
    .init(category: .birthday, name: "test", toDoDescription: "", image: Data(), executedDate: .now, startExecutedTime: nil, endExecutedTime: nil, numbersOfReminders: 1),
    .init(category: .holidayEvent, name: "test2", toDoDescription: "", image: Data(), executedDate: .now, startExecutedTime: nil, endExecutedTime: nil, numbersOfReminders: 1),
    .init(category: .birthday, name: "test3", toDoDescription: "", image: Data(), executedDate: .now, startExecutedTime: nil, endExecutedTime: nil, numbersOfReminders: 1)
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
final class HomeViewModel: ViewModelInterface {
    enum State: Equatable {
        case idle
        case loading
        case loaded([ToDo])
        case error(String)
    }
    
    enum Event {
        case getWeek
        case getTasks
        case presentAddTaskViewButtonPressed
        case changeDayButtonPressed(Date)
        case onPreferenceChangeOffsetAction(CGFloat)
        case updateTask(ToDo)
        case onCreateWeekAction
        case onChangeCategoryButtonPressed(ToDoInterface.Category)
    }
    
    @Published private(set) var state: State = .idle
    @Published private(set) var currentDate: Date = .init()
    @Published private(set) var weekSlider: [[Date.WeekDay]] = []
    @Published private(set) var createWeek: Bool = false
    @Published private(set) var isDone: Bool = false
    @Published private(set) var tasks: [ToDo] = []
    @Published private(set) var selectedCategory: ToDoInterface.Category = .all
    @Published var currentWeekIndex: Int = 1
    @Published var doneTaskPercentage: Double = 0.0
    @Published var categorizedCounts: [String: CategoryInfo] = ["Done your tasks": .init(count: 1, color: Colors.color)]
    @Published var isAddTaskViewPresented: Bool = false
    @Inject private var toDoManager: ToDoManagerInterface
    
    var tasksByCategoryCounts: [ToDoInterface.Category: Int] {
        var counts: [ToDoInterface.Category: Int] = [:]
        
        for category in ToDoInterface.Category.allCases {
            if category == .all {
                counts[category] = tasks.count
            } else {
                counts[category] = tasks.filter { $0.category == category }.count
            }
        }
        return counts
    }
    
    init() {
        trigger(.getTasks)
    }
    
    func trigger(_ event: Event) {
        switch event {
        case .getWeek:
            fetchWeek()
        case .getTasks:
            fetchFilteredTasks()
        case .presentAddTaskViewButtonPressed:
            presentAddTaskViewButtonPressed()
        case .changeDayButtonPressed(let day):
            changeDayButtonPressed(day)
        case .onPreferenceChangeOffsetAction(let value):
            onPreferenceChangeOffsetAction(value)
        case .updateTask(let task):
            updateTask(task: task)
        case .onCreateWeekAction:
            onCreateWeekAction()
        case .onChangeCategoryButtonPressed(let category):
            onChangeCategoryButtonPressed(category: category)
        }
    }

    private func presentAddTaskViewButtonPressed() {
        isAddTaskViewPresented.toggle()
    }

    private func onChangeCategoryButtonPressed(category: ToDoInterface.Category) {
        selectedCategory = category
        filterTaskByCategory()
    }

    private func numberOfCompletedTasksPerCategory() -> [String: CategoryInfo] {
        var counts = [String: Int]()
        
        for task in tasks {
            if task.isDone {
                if let count = counts[task.category.rawValue] {
                    counts[task.category.rawValue] = count + 1
                } else {
                    counts[task.category.rawValue] = 1
                }
            }
        }
        
        let sortedCounts = counts.sorted(by: { $0.key < $1.key })
        
        var categorizedCounts = [String: CategoryInfo]()
        
        let colors = [Colors.color, Colors.color1, Colors.color2]
        
        for (index, (category, count)) in sortedCounts.enumerated() {
            if index < 2 {
                categorizedCounts[category] = CategoryInfo(count: count, color: colors[index])
            } else {
                if let otherCount = categorizedCounts["Other"] {
                    categorizedCounts["Other"] = CategoryInfo(count: otherCount.count + count, color: otherCount.color)
                } else {
                    categorizedCounts["Other"] = CategoryInfo(count: count, color: colors[index])
                }
            }
        }
        return categorizedCounts
    }
}

//MARK: Functions to service dates
extension HomeViewModel {
    private func fetchWeek() {
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
    
    private func changeDayButtonPressed(_ day: Date) {
        withAnimation(.snappy) {
            currentDate = day
        }
    }
    
    private func onPreferenceChangeOffsetAction(_ value: CGFloat) {
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
    
    private func onCreateWeekAction() {
        createWeek = true
    }
}

//MARK: Functions to service task
extension HomeViewModel {
    @discardableResult
    private func filterTaskByCategory() -> [ToDo] {
        if selectedCategory == .all {
            state = .loaded(self.tasks)
            print("All tasks:\n", tasks)
            return tasks
        } else {
            let filteredTasks = tasks.filter { $0.category == selectedCategory }
            print("Filtered tasks:\n",filteredTasks)
            state = .loaded(filteredTasks)
            return filteredTasks
        }
    }
    
    private func fetchFilteredTasks() {
        guard state == .idle else { return }
        
        state = .loading
        
        Task {
            do {
//                self.tasks = try await toDoManager.readAllToDos()
                self.tasks = toDoMocks
                
                calculateDoneTaskPercentage()
                
                filterDoneTasks()
                
                state = .loaded(filterTaskByCategory())
                
            } catch {
                state = .error(error.localizedDescription)
            }
        }
    }
    
    private func updateTask(task: ToDo) {
        Task {
            do {
                
                let data: [String : Any] = [
                    ToDo.CodingKeys.id.rawValue : task.id,
                    ToDo.CodingKeys.isDone.rawValue : !task.isDone
                ]

                try await toDoManager.updateToDo(data: data)

                if let index = self.tasks.firstIndex(where: { $0.id == task.id }) {
                    self.tasks[index] = ToDo(task: task, isDone: !task.isDone)
                }
                
                filterDoneTasks()
                
                calculateDoneTaskPercentage()
                
                print("todo state is updated")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: Functions to service filtering
extension HomeViewModel {
    private func filterDoneTasks() {
        guard tasks.filter({ $0.isDone }).isEmpty else {
            self.categorizedCounts = numberOfCompletedTasksPerCategory()
            state = .loaded(filterTaskByCategory())
            return
        }
        self.categorizedCounts = ["Done your tasks": .init(count: 1, color: Colors.color)]
        state = .loaded(filterTaskByCategory())
    }
    
    private func calculateDoneTaskPercentage() {
        let allToDo = tasks.count
        let doneToDo = tasks.filter({ $0.isDone }).count
        
        guard allToDo > 0 && doneToDo > 0 else {
            self.doneTaskPercentage = 0
            return
        }
        
        self.doneTaskPercentage = Double(doneToDo) / Double(allToDo) * 100
    }
}
