//
//  TaskProgressChartView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 25/06/2024.
//

import Charts
import Design
import SwiftUI
import ToDoInterface

struct TaskProgressChartView: View {
    let action: () -> Void
    @Binding var taskDonePercentage: Int
    @Binding var categorizedCounts: [String: CategoryInfo]
    
    init(taskDonePercentage: Binding<Int>, categorizedCounts: Binding<[String: CategoryInfo]>, action: @escaping () -> Void) {
        self._taskDonePercentage = taskDonePercentage
        self._categorizedCounts = categorizedCounts
        self.action = action
    }
    
    var body: some View {
        Rectangle()
            .fill(Colors.ghostWhite).opacity(0.2)
            .clipShape(.rect(cornerRadius: 30))
            .frame(height: 200)
            .overlay {
                GeometryReader { reader in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Daily Tasks")
                                .font(.size23Default)
                            
                            VStack(alignment: .leading) {
                                ForEach(categorizedCounts.sorted(by: { $0.key < $1.key }), id: \.key) { category, info in
                                    CategoryNameRow(category: category, color: info.color)
                                }
                            }
                            .vSpacing(.center)
                        }
                        .frame(maxWidth: reader.size.width * 0.5, alignment: .leading)
                        .padding(.leading)
                        
                        categoryChart
                            .frame(maxWidth: reader.size.width * 0.5)
                    }
                    
                }
                .padding(.vertical, 30)
            }
            .foregroundStyle(Colors.ghostWhite)
    }
}

#Preview {
    ZStack {
        Colors.background().ignoresSafeArea()
        TaskProgressChartView(taskDonePercentage: .constant(0), categorizedCounts: .constant(["": CategoryInfo(count: 1, color: .purple)])) { }
    }
}

extension TaskProgressChartView {
    private func CategoryNameRow(category: String, color: Color) -> some View {
        HStack(spacing: 15) {
            Circle()
                .fill(color)
                .frame(width: 8)
            
            Text(category)
                .font(.size15Default)
        }
    }
    
    private var categoryChart: some View {
        ZStack(alignment: .topTrailing) {
            Chart {
                ForEach(categorizedCounts.sorted(by: { $0.key < $1.key }), id: \.key) { category, task in
                    
                    SectorMark(angle: .value("Task", task.count), innerRadius: .ratio(0.618), angularInset: 0)
                        .foregroundStyle(task.color)
                }
            }
            .chartLegend(.hidden)
            .overlay {
                Text("\(taskDonePercentage)%")
                    .font(.size23Default)
            }
            
            Button {
                //action
            } label: {
                Image(systemName: Symbols.ellipsis)
                    .imageScale(.large)
                    .foregroundStyle(Colors.ghostWhite)
            }
            .padding(.trailing, 25)
        }
    }
}


