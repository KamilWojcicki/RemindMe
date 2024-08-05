//
//  HomeViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 23/06/2024.
//

import DependencyInjection
import Design
import SwiftUI
import Utilities
import ToDoInterface



@MainActor
final class HomeViewModel: ObservableObject {
    @Published var currentDate: Date = .init()
    @Published var weekSlider: [[Date.WeekDay]] = []
    @Published var currentWeekIndex: Int = 1
    @Published var createWeek: Bool = false
    @Published var isDone: Bool = false
    @Published var tasks: [ToDo] = []
    @Published var task: ToDo?
    @Published var selectedCategory: ToDoInterface.Category = .all
    @Published var doneTaskPercentage: Int = 30
    @Published var categorizedCounts: [String: CategoryInfo] = ["Done your tasks": .init(count: 1, color: Colors.color)]
    @Inject private var toDoManager: ToDoManagerInterface
    
    var filteredTasks: [ToDo] {
        if selectedCategory == .all {
            return tasks
        } else {
            return tasks.filter { $0.category == selectedCategory }
        }
    }
    
    var categoryCounts: [ToDoInterface.Category: Int] {
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
        fetchTasks()
    }
    
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
    
    func paginateWeek() {
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
    
    private func fetchTasks() {
        Task {
            do {
                self.tasks = try await toDoManager.readAllToDos()
                
                calculateDoneTaskPercentage()
                
                guard tasks.filter({ $0.isDone }).isEmpty else {
                    self.categorizedCounts = numberOfCompletedTasksPerCategory()
                    return
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateTask(task: ToDo, isOn: Bool) {
        Task {
            do {
                
                let data: [String : Any] = [
                    ToDo.CodingKeys.id.rawValue : task.id,
                    ToDo.CodingKeys.isDone.rawValue : isOn
                ]
                
                try await toDoManager.updateToDo(data: data)
                
                fetchTasks()
                
                print("todo state is updated")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func calculateDoneTaskPercentage() {
       let allToDo = tasks.count
       let doneToDo = tasks.filter({ $0.isDone }).count
       
       guard allToDo > 0 else {
           self.doneTaskPercentage = 69
           return
       }

       self.doneTaskPercentage = Int(Double(doneToDo) / Double(allToDo) * 100)
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
