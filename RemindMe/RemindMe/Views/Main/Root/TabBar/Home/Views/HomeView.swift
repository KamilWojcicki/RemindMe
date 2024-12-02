//
//  HomeView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 23/06/2024.
//

import Components
import Design
import Utilities
import Navigation
import SwiftUI
import ToDoInterface

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var router: Router<Routes>
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                CustomProgressView(message: "Loading...")
            case .loaded:
                buildHomeView
            case .error(let error):
                CustomErrorView(message: error.description) {
                    Task {
                        do {
                            try await viewModel.fetchToDos()
                        } catch {
                            viewModel.handleError(error: error)
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchWeek()
        }
        .task {
            do {
                try await viewModel.fetchToDos()
            } catch {
                viewModel.handleError(error: error)
            }
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
    private var buildHomeView: some View {
        ZStack {
            VStack(spacing: 10) {
                header
                
                taskProgress
                
                buildtasksView
            }
            .vSpacing(.top)
            .padding(.horizontal)
            .withModal(
                .fullScreenCover,
                destinationView: AddToDoView(),
                isPresented: $viewModel.isAddToDoViewPresented
            )
            .withModal(
                .sheet,
                destinationView: ToDoDetailView(toDo: viewModel.selectedToDo),
                isPresented: $viewModel.isDetailViewPresented,
                presentationDetent: .fraction(0.99)
            )
        }
    }
    
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
                viewModel.onCreateWeekAction()
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
                        .fill(Colors.ghostWhite.opacity(day.date.isSameDay(as: viewModel.currentDate) ? 1 : 0.17))
                        .overlay {
                            Text(day.date.format("dd"))
                                .font(.footnote)
                        }
                }
                .foregroundStyle(day.date.isSameDay(as: viewModel.currentDate) ? Colors.night : Colors.ghostWhite.opacity(0.8))
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
                    day.date.isSameDay(as: viewModel.currentDate) ? Colors.vistaBlue : Colors.night.opacity(0.9), in: .rect(cornerRadius: 20)
                )
                .hSpacing(.center)
                .contentShape(Circle())
                .onTapGesture {
                    viewModel.changeDayButtonPressed(day.date)
                }
            }
        }
        .onPreferenceChangeKey { value in
            viewModel.onPreferenceChangeOffsetAction(value)
        }
    }
    
    private var taskProgress: some View {
        ToDoProgressChartView(toDoDonePercentage: $viewModel.doneToDoPercentage, categorizedCounts: $viewModel.categorizedCounts) {
            #warning("action to change filter not implemented")
        }
    }
    
    @ViewBuilder
    private var buildtasksView: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                Symbols.squareGrid
                Text("Tasks")
                
                Spacer()
                
                addButtonView
            }
            .font(.size18Default)
            .padding(.vertical, 10)
            .foregroundStyle(Colors.ghostWhite)
            .padding(.horizontal)
            
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(ToDoInterface.Tag.allCases, id: \.self) { tag in
                        buildCategoryCellView(categoryTitle: tag.rawValue, taskCount: viewModel.tasksByCategoryCounts[tag] ?? 0, isSelected: viewModel.selectedCategory == tag)
                            .padding(.leading, 15)
                            .padding(.trailing, tag == .otherEvent ? 15 : 0)
                            .onTapGesture {
                                    viewModel.onChangeCategoryButtonPressed(category: tag)
                            }
                    }
                }
            }
            .scrollIndicators(.never)
            
            ScrollView(.vertical) {
                VStack {
                    ForEach(Array(viewModel.filteredToDos.enumerated()), id: \.element) { (index, toDo) in

                        ToDoInfoCellView(
                            toDo: toDo,
                            onDetailAction: {
                                viewModel.presentDetailViewButtonPressed(index: index)
                            }, onErrorAction: { error in
                                viewModel.handleError(error: error)
                            }
                        )
                        .padding(.horizontal)
                        .transition(.move(edge: .leading))
                    }
                }
                .offset(y: 10.0)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.never)
            .frame(maxHeight: 260)
            .withFadeOut(topFadeLength: 15, bottomFadeLength: 50)
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
        .clipShape(.rect(cornerRadius: 25))
    }
    
    private var addButtonView: some View {
        Button {
            viewModel.presentAddToDoViewButtonPressed()
        } label: {
            HStack(spacing: 0) {
                Symbols.plus
                    .padding(10)
                    .background(Colors.ghostWhite.opacity(0.2))
                    .clipShape(Circle())
            }
        }
    }
}

