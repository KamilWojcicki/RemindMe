//
//  AddTaskView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 10/08/2024.
//

import Components
import Design
import SwiftUI

struct AddTaskView: View {
    @StateObject private var viewModel = AddTaskViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ReadableScrollView(content: {
                VStack(spacing: 15) {
                    Text("New Task")
                    
                    Row(
                        text: viewModel.newTaskTitle,
                        variant: .title(
                            icon: viewModel.newTaskSymbol,
                            instruction: "Tap to rename and change the image"
                        )
                    ) {
                        
                    }
                    
                    Row(
                        text: "Today",
                        variant: .plainText(
                            symbol: Symbols.calendar
                        )
                    ) {
                        
                    }
                    
                    Row(
                        text: "Time: \(viewModel.taskTime)",
                        variant: .plainText(
                            symbol: Symbols.stopwatchFill
                        )
                    ) {
                        
                    }
                    
                    Row(
                        text: "Remind: \(viewModel.remindTime)",
                        variant: .plainText(
                            symbol: Symbols.clockBadgeExclamationmarkFill
                        )
                    ) {
                        
                    }
                    
                    Row(
                        text: "\(viewModel.repetition.description)",
                        variant: .plainText(
                            symbol: Symbols.clockArrowCirclepath
                        )
                    ) {
                        
                    }
                    
                    Row(
                        text: "No tag",
                        variant: .plainText(
                            symbol: Symbols.tagFill
                        )
                    ) {
                        
                    }
                    
                    Row(
                        text: "Subtask",
                        variant: .subtask(
                            symbol: Symbols.plus
                        )) {
                            
                        }
                    
                    PhotoAttacher(defaultScrollAnchor: $viewModel.defaultScrollAnchor) {
                        //action/attach photo/open photo library
                    } deletePhotoAction: {
                        //delete action
                    }
                }
                .padding()
            }, onScroll: { position in
                viewModel.onScrollDividerAction()
            })
            .scrollIndicators(.hidden)
            .defaultScrollAnchor(viewModel.defaultScrollAnchor)
            .safeAreaInset(edge: .bottom,spacing: 0) {
                VStack(spacing: 0) {
                    if viewModel.showDivider {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Colors.night.opacity(0.1))
                            .frame(height: 2)
                            .frame(maxWidth: .infinity)
                    }
                        
                        ConfirmButton(title: "Create Task") {
                            dismiss()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                        .padding(.top, 10)
                        .background(Colors.ghostWhite)
                }
                
                }
        }
        .background(Colors.ghostWhite)
    }
}

#Preview {
    AddTaskView()
}
