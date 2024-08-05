//
//  HomeView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 23/06/2024.
//

import Design
import Utilities
import SwiftUI
import ToDoInterface

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(spacing: 10) {
            header
            
            taskProgress
            
            tasks
        }
        .vSpacing(.top)
        .padding(.horizontal)
        .onAppear {
            viewModel.fetchWeek()
        }
    }
}

#Preview {
    ZStack {
        Colors.background().ignoresSafeArea()
        HomeView()
    }
    
}

extension HomeView {
    private var header: some View {
        VStack {
            Text("Today")
                .foregroundStyle(Colors.ghostWhite)
                .font(.size18DefaultBold)
            
            TabView(selection: $viewModel.currentWeekIndex) {
                ForEach(viewModel.weekSlider.indices, id: \.self) { index in
                    let week = viewModel.weekSlider[index]
                    buildWeekView(week)
                        .padding(.horizontal, 10)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 85)
            .padding(.horizontal, -16)
        }
        .onChange(of: viewModel.currentWeekIndex, initial: false) { oldValue, newValue in
            if newValue == 0 || newValue == (viewModel.weekSlider.count - 1) {
                viewModel.createWeek = true
            }
        }
    }
    
    @ViewBuilder
    private func buildWeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 8) {
                    Text(day.date.customDayAbbreviation())
                        .font(.caption)
                        .textScale(.secondary)
                    
                    Circle()
                        .fill(Colors.ghostWhite.opacity(isSameDate(day.date, viewModel.currentDate) ? 1 : 0.17))
                        .overlay {
                            Text(day.date.format("dd"))
                                .font(.footnote)
                        }
                }
                .foregroundStyle(isSameDate(day.date, viewModel.currentDate) ? Colors.night : Colors.ghostWhite.opacity(0.8))
                .padding(5)
                .frame(width: 40, height: 65)
                .background(content: {
                    if day.date.isToday {
                        Circle()
                            .fill(Colors.blue)
                            .frame(width: 5, height: 5)
                            .vSpacing(.bottom)
                            .offset(y: 10)
                    }
                })
                .background(
                    isSameDate(day.date, viewModel.currentDate) ? Colors.vistaBlue : Colors.night.opacity(0.9), in: .rect(cornerRadius: 20)
                )
                .hSpacing(.center)
                .contentShape(Circle())
                .onTapGesture {
                    viewModel.changeDayButtonPressed(day.date)
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        viewModel.onPreferenceChangeOffsetAction(value)
                    }
            }
        }
    }
    
    private var taskProgress: some View {
        TaskProgressChartView(taskDonePercentage: $viewModel.doneTaskPercentage, categorizedCounts: $viewModel.categorizedCounts) {
            
        }
    }
    
    private var tasks: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Image(systemName: Symbols.squareGrid)
                Text("Tasks")
                    .font(.size18Default)
            }
            .foregroundStyle(Colors.ghostWhite)
            .padding(.horizontal)
            
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(ToDoInterface.Category.allCases, id: \.self) { category in
                        buildCategoryCellView(categoryTitle: category.rawValue, taskCount: viewModel.categoryCounts[category] ?? 0, isSelected: viewModel.selectedCategory == category)
                            .padding(.leading, 15)
                            .padding(.trailing, category == .otherEvent ? 15 : 0)
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    viewModel.selectedCategory = category
                                }
                            }
                    }
                }
            }
            .scrollIndicators(.never)
            
            ScrollView(.vertical) {
                VStack {
                    ForEach(viewModel.filteredTasks) { task in
                        TaskInfoCellView(
                            image: .checkmark,
                            executeTime: task.startExecutedTime ?? Date(),
                            taskTitle: task.name,
                            isDone: Binding(
                                get: {
                                    task.isDone
                                },
                                set: {
                                    viewModel.updateTask(task: task, isOn: $0)
                                }
                            )
                        )
                        .padding(.horizontal)
                        .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    }
                }
                .offset(y: 10.0)
            }
            .scrollIndicators(.never)
            .withFadeOut(topFadeLength: 10, bottomFadeLength: 20)
        }
        .padding(.top, 10)
        .padding(.horizontal, -15)
    }
    
    @ViewBuilder
    private func buildCategoryCellView(categoryTitle: String, taskCount: Int, isSelected: Bool = false) -> some View {
        HStack {
            Text(categoryTitle.capitalized)
            
            RoundedRectangle(cornerRadius: 40)
                .fill(isSelected ? Colors.blue.opacity(0.8) : Colors.ghostWhite)
                .overlay(alignment: .center) {
                    Text(String(taskCount))
                        .foregroundStyle(isSelected ? Colors.ghostWhite : Colors.night)
                }
                .frame(width: 30, height: 20)
        }
        .padding(6)
        .padding(.horizontal, 4)
        .font(.size15Default)
        .foregroundStyle(Colors.ghostWhite)
        .background(isSelected ? Colors.color2 : Colors.ghostWhite.opacity(0.2))
        .clipShape(.rect(cornerRadius: 40))
    }
}
