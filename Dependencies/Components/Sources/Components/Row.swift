//
//  Row.swift
//
//
//  Created by Kamil Wójcicki on 15/08/2024.
//

import Design
import SwiftUI
import ToDoInterface

public struct Row: View {
    public enum Variant {
        case title(icon: Icon, instruction: String)
        case plainText(symbol: Image)
        case subtask(symbol: Image)
        case subtaskWithCheckmark(subtask: SubToDo)
    }
    
    private let text: String
    private let variant: Variant
    private let action: () -> Void
    
    public init(
        text: String,
        variant: Variant,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.variant = variant
        self.action = action
    }
    
    public var body: some View {
        buildRowView(for: variant)
            .padding()
            .background(Colors.ghostWhite)
            .clipShape(.rect(cornerRadius: 15))
            .shadow(radius: 3)
            .onTapGesture {
                action()
            }
    }
    
    @ViewBuilder
    private func buildRowView(for variant: Variant) -> some View {
        switch variant {
        case .title(let icon, let instruction):
            buildTitle(icon: icon, instruction: instruction)
        case .plainText(let symbol):
            buildPlainText(symbol: symbol)
        case .subtask(let symbol):
            buildSubtask(symbol: symbol)
        case .subtaskWithCheckmark(let subtask):
            buildSubtaskWithCheckmark(subtask: subtask)
        }
    }
    
    private func buildPlainText(symbol: Image) -> some View {
        HStack {
            buildText(text)
            
            Spacer()
            
            symbol
                .font(.size22Default)
        }
    }
    
    private func buildSubtask(symbol: Image) -> some View {
        HStack(spacing: 20) {
            symbol
                .font(.size22Default)
            
            buildText(text)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func buildSubtaskWithCheckmark(subtask: SubToDo) -> some View {
        HStack(spacing: 20) {
            Button {
                action()
            } label: {
                let image = subtask.isCompleted ? Symbols.checkmarkSealFill : Symbols.circle
                
                image
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(subtask.isCompleted ? Colors.mantis : Colors.night.opacity(0.5))
            }
            
            buildText(text)
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func buildTitle(icon: Icon, instruction: String) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(spacing: 20) {
                CircularIcon(icon: icon)
                
                buildText(text)
                    .font(.size22Default)
            }
            
            Text(instruction)
                .font(.size15Default)
                .foregroundStyle(Colors.night.opacity(0.4))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Colors.ghostWhite)
        
    }
    
    private func buildText(_ text: String) -> some View {
        Text(text)
    }
}

#Preview {
    VStack(spacing: 30) {
        Row(text: "Test", variant: .title(icon: .clipboardIcon, instruction: "This is the instruction")) { }
        Row(text: "Test", variant: .subtask(symbol: Symbols.airplaneCircleFill)) { }
        Row(text: "Test", variant: .plainText(symbol: Symbols.airplaneCircleFill)) { }
        Row(text: "Test", variant: .subtaskWithCheckmark(subtask: .init(title: "test", isCompleted: true))) { }
    }
}
