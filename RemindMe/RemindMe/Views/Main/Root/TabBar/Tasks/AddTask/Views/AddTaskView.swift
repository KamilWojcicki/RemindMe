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
                    
                    Rectangle()
                        .fill(Colors.ghostWhite)
                        .clipShape(.rect(topLeadingRadius: 40, topTrailingRadius: 40))
                        .overlay {
                            if let selectedCategory = secViewModel.toDoCategory {
                                buildCategoryView(for: selectedCategory)
                            }
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .shadow(color: Colors.night.opacity(0.5), radius: 10)
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
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter
    }
    
    private var divider: some View {
        Divider()
            .frame(height: 1)
            .background(Colors.ghostWhite.opacity(0.5))
            .textInputAutocapitalization(.never)
    }
    
    @ViewBuilder
    private var datePickerField: some View {
        Text("Date")
            .font(.body).opacity(0.7)
        
        Text(dateFormatter.string(from: viewModel.selectDate))
            .foregroundStyle(Colors.ghostWhite)
            .overlay {
                DatePicker(
                    "",
                    selection: $viewModel.selectDate,
                    displayedComponents: .date
                )
                .blendMode(.destinationOver)
                .labelsHidden()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.system(size: 23, weight: .bold, design: .default))
        
        divider
    }
    
    @ViewBuilder
    private var titleTextField: some View {
        Text("Title")
            .font(.body).opacity(0.7)
        
        TextField(textFieldLogin: $viewModel.titleTextFieldText)
        
        divider
    }
    
    @ViewBuilder
    private var picker: some View {
        Colors.night.ignoresSafeArea().opacity(0.3)
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
                BirthdayView()
            case .shoppingList:
                ShoppingListView()
            case .holidayEvent:
                HolidayView()
            case .medicalCheck:
                MedicalCheckView()
            case .trip:
                TripView()
            case .otherEvent:
                OtherEventView()
            }
            
            Spacer()
            
            ConfirmButton(title: "Create Task") {
                //add task action
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.vertical, 20)
        }
        .padding(30)
    }
}
