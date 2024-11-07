//
//  TaskInfoCellView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 29/06/2024.
//

import Components
import Design
import SwiftUI
import ToDoInterface
import Utilities

struct TaskInfoCellView: View {
    let task: ToDo
    let backgroundColor: Color
    let onDetailAction: (() -> Void)?
    @StateObject private var viewModel = TaskInfoCellViewModel()

    init(
        task: ToDo,
        backgroundColor: Color = Colors.ghostWhite,
        onDetailAction: (() -> Void)? = nil
    ) {
        self.task = task
        self.backgroundColor = backgroundColor
        self.onDetailAction = onDetailAction
    }
    
    var body: some View {
        HStack(spacing: 20) {
            CircularIcon(icon: task.symbol)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Symbols.stopwatchFill
                    
                    Text(dateFormatter(dateFormat: .timeWithPeriods).string(from: task.executedTime))
                }
                .foregroundStyle(Colors.night.opacity(0.5))
                .font(.size15Default)
                
                Text(task.name)
                    .foregroundStyle(Colors.night)
                    .font(.size22Default)
            }
            
            Spacer()
            
            Button {
                withAnimation(.default) {
                    viewModel.updateTask(task: task)
                }
            } label: {
                let image = task.isDone ? Symbols.checkmarkSealFill : Symbols.circle
                
                image
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(task.isDone ? Colors.mantis : Colors.night.opacity(0.5))
            }
        }
        .frame(minWidth: 325, maxHeight: 50)
        .padding()
        .background(backgroundColor)
        .clipShape(.rect(cornerRadius: 25))
        .onTapGesture {
            onDetailAction?()
        }
    }
}

#Preview {
    TaskInfoCellView(task: toDoMocks.first!) { }
}
