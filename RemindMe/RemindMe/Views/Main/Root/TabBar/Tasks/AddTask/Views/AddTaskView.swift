//
//  AddTaskView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 15/05/2024.
//

import Components
import Design
import SwiftUI
import Navigation
import ToDoInterface
import Utilities



struct AddTaskView: View {
    @StateObject private var viewModel = AddTaskViewModel()
    @EnvironmentObject private var secViewModel: TabBarViewModel
    @EnvironmentObject private var router: Router<Routes>
    
    var body: some View {
        ZStack {
            Colors.background().ignoresSafeArea()
            
            VStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 10) {
                    header
                    
                    titleTextField
                    
                    datePickerField
                }
                .foregroundStyle(Colors.ghostWhite)
                .padding(.horizontal, 25)
                
                Spacer()
                
                GeometryReader { geometry in
                    buildOverlayContent
                }
                .ignoresSafeArea()
            }
            .disabled(viewModel.showCategories)
            
            if viewModel.showCategories {
               picker
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.showCategoryPickerWhenCategoryIsNil(using: secViewModel)
        }
        .animation(.spring(duration: 0.6), value: viewModel.showCategories)
    }
}

#Preview {
    AddTaskView()
        .environmentObject(TabBarViewModel())
}

extension AddTaskView {
    @ViewBuilder
    private var datePickerField: some View {
        Text("Date")
            .withOpacityFont(foregroundColor: Colors.ghostWhite)
    
        Text(dateFormatter(dateFormat: .date).string(from: viewModel.selectDate))
            .foregroundStyle(Colors.ghostWhite)
            .overlay {
                DatePicker(
                    "",
                    selection: $viewModel.selectDate,
                    in: Date()...,
                    displayedComponents: .date
                )
                .blendMode(.destinationOver)
                .labelsHidden()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.size23Default)
        
        OpacityDivider()
    }
    
    @ViewBuilder
    private var titleTextField: some View {
        Text("Title")
            .withOpacityFont(foregroundColor: Colors.ghostWhite)
        
        TextField(textFieldLogin: $viewModel.titleTextFieldText)
            .textInputAutocapitalization(.never)
        
        OpacityDivider()
    }
    
    @ViewBuilder
    private var picker: some View {
        Colors.night.ignoresSafeArea().opacity(0.3)
            .onTapGesture {
                viewModel.showCategoryPickerView()
            }
        CategoryPickerView(showPickerView: $viewModel.showCategories)
            .padding()
    }
    
    private var header: some View {
        HStack {
            Button {
                secViewModel.toDoCategory = nil
                router.navigateBack()
                
            } label: {
                Image(systemName: Symbols.arrowLeft)
            }
            
            Spacer()
            
            Text("Create a Task")
            
            Spacer()
            
            Button {
                viewModel.showCategoryPickerView()
            } label: {
                Image(systemName: Symbols.line3Horizontal)
            }
        }
        .padding(.bottom, 30)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func buildCategoryView(for category: Categories) -> some View {
        VStack {
            switch category {
            case .birthday:
                CategoriesView(startTimeTitle: "Starting Party", endTimeTitle: "Ending Party", description: "List of guests")
            case .shoppingList:
                CategoriesView(startTimeTitle: "Shopping Time", endTimeTitle: nil, description: "List of products")
            case .holidayEvent:
                CategoriesView(startTimeTitle: "Starting Holiday", endTimeTitle: "Ending Holiday", description: "Holiday Description")
            case .medicalCheck:
                CategoriesView(startTimeTitle: "Starting visit", endTimeTitle: nil, description: "Visit Description")
            case .trip:
                CategoriesView(startTimeTitle: "Starting Trip", endTimeTitle: "Ending Trip", description: "Plan of a Trip")
            case .otherEvent:
                CategoriesView(startTimeTitle: "Starting Event", endTimeTitle: "Ending Event", description: "Event Description")
            }
        }
    }
    
    private var buildOverlayContent: some View {
        Rectangle()
            .fill(Colors.ghostWhite)
            .clipShape(.rect(topLeadingRadius: 40, topTrailingRadius: 40))
            .overlay {
                VStack {
                    if let selectedCategory = secViewModel.toDoCategory {
                        buildCategoryView(for: selectedCategory)
                    } else {
                        CategoriesView()
                    }
                    
                    Spacer()
                    
                    ConfirmButton(title: "Create Task") {
                        //add task action
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.vertical, 20)
                }
                .padding(20)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .shadow(color: Colors.night.opacity(0.5), radius: 10)
    }
}
