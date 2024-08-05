//
//  TaskInfoCellView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 29/06/2024.
//

import Design
import SwiftUI
import Utilities

struct TaskInfoCellView: View {
    let image: UIImage
    let executeTime: Date
    let taskTitle: String
    @Binding var isDone: Bool
    
    init(image: UIImage, executeTime: Date, taskTitle: String, isDone: Binding<Bool>) {
        self.image = image
        self.executeTime = executeTime
        self.taskTitle = taskTitle
        self._isDone = isDone
    }
    
    var body: some View {
        HStack {
            Image(uiImage: image)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(Colors.ghostWhite)
                .padding(8)
                .background(Colors.vistaBlue, in: .circle)
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "stopwatch.fill")
                    Text(dateFormatter(dateFormat: .timeWithPeriods).string(from: executeTime))
                }
                .foregroundStyle(Colors.night.opacity(0.5))
                .font(.size15Default)
                
                Text(taskTitle)
                    .font(.size22Default)
            }
            
            Button {
                withAnimation(.default) {
                    isDone.toggle() 
                }
            } label: {
                Image(systemName: isDone ? Symbols.checkmarkSealFill : Symbols.circle)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .hSpacing(.trailing)
                    .foregroundStyle(isDone ? Colors.mantis : Colors.night.opacity(0.5))
            }
        }
        .hSpacing(.leading)
        .padding()
        .background(Colors.ghostWhite)
        .clipShape(.rect(cornerRadius: 30))
    }
}

#Preview {
    TaskInfoCellView(
        image: .checkmark,
        executeTime: Date(),
        taskTitle: "Test",
        isDone: .constant(false)
    )
}
