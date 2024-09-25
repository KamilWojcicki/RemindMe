//
//  TaskInfoCellView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 29/06/2024.
//

import Design
import SwiftUI
import ToDoInterface
import Utilities

struct TaskInfoCellView: View {
    let task: ToDo
    var action: () -> Void

    init(
        task: ToDo,
        action: @escaping () -> Void
    ) {
        self.task = task
        self.action = action
    }
    
    var body: some View {
        HStack {
            if let image = task.image, let uiImage = UIImage(data: image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(Colors.ghostWhite)
                    .padding(8)
                    .background(Colors.vistaBlue, in: .circle)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "stopwatch.fill")
                    Text(dateFormatter(dateFormat: .timeWithPeriods).string(from: task.startExecutedTime ?? .now))
                }
                .foregroundStyle(Colors.night.opacity(0.5))
                .font(.size15Default)
                
                Text(task.name)
                    .foregroundStyle(Colors.night)
                    .font(.size22Default)
            }
            
            Button {
                withAnimation(.default) {
                    action()
                }
            } label: {
                let image = task.isDone ? Symbols.checkmarkSealFill : Symbols.circle
                
                image
                    .resizable()
                    .frame(width: 30, height: 30)
                    .hSpacing(.trailing)
                    .foregroundStyle(task.isDone ? Colors.mantis : Colors.night.opacity(0.5))
            }
        }
        .frame(minWidth: 320, maxHeight: 50)
        .hSpacing(.leading)
        .padding()
        .background(Colors.ghostWhite)
        .clipShape(.rect(cornerRadius: 25))
    }
}

#Preview {
    TaskInfoCellView(
        task: ToDo(
            category: .birthday,
            name: "Test",
            toDoDescription: "",
            image: Data(),
            executedDate: .now,
            startExecutedTime: nil,
            endExecutedTime: nil,
            numbersOfReminders: 0
        )) {
            
        }
}
