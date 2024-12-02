//
//  ToDoInfoCellView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 29/06/2024.
//

import Components
import Design
import SwiftUI
import ToDoInterface
import Utilities

struct ToDoInfoCellView: View {
    let toDo: ToDo
    let backgroundColor: Color
    let onDetailAction: (() -> Void)?
    let onErrorAction: (Error) -> Void
    @StateObject private var viewModel = ToDoInfoCellViewModel()

    init(
        toDo: ToDo,
        backgroundColor: Color = Colors.ghostWhite,
        onDetailAction: (() -> Void)? = nil,
        onErrorAction: @escaping (Error) -> Void
    ) {
        self.toDo = toDo
        self.backgroundColor = backgroundColor
        self.onDetailAction = onDetailAction
        self.onErrorAction = onErrorAction
    }
    
    var body: some View {
        buildToDoInfoCellView
    }
}

#Preview {
    ToDoInfoCellView(toDo: toDoMocks.first!) { _ in }
}

extension ToDoInfoCellView {
    private var buildToDoInfoCellView: some View {
        HStack(spacing: 20) {
            CircularIcon(icon: Icon.icon(for: toDo.symbol))
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Symbols.stopwatchFill
                    
                    Text(dateFormatter(dateFormat: .timeWithPeriods).string(from: toDo.executedTime))
                }
                .foregroundStyle(Colors.night.opacity(0.5))
                .font(.size15Default)
                
                Text(toDo.name)
                    .foregroundStyle(Colors.night)
                    .font(.size22Default)
            }
            
            Spacer()
            
            Button {
                Task {
                    do {
                        try await viewModel.updateToDo(toDo: toDo)
                    } catch {
                        onErrorAction(error)
                    }
                }
            } label: {
                let image = toDo.isDone ? Symbols.checkmarkSealFill : Symbols.circle
                
                image
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(toDo.isDone ? Colors.mantis : Colors.night.opacity(0.5))
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
