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
    @StateObject private var viewModel: AddTaskViewModel
    @EnvironmentObject private var router: Router<Routes>
    @Binding private var toDoToEdit: ToDo?
    
    init(toDoToEdit: Binding<ToDo?> = .constant(nil), category: ToDoInterface.Category?) {
        self._toDoToEdit = toDoToEdit
        self._viewModel = StateObject(wrappedValue: AddTaskViewModel(category: category))
    }
    
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
        .task {
            try? await viewModel.readToDoToEdit(id: toDoToEdit?.id ?? "")
            viewModel.showCategoryPickerIfCategoryIsNil()
            
        }
        .animation(.spring(duration: 0.6), value: viewModel.showCategories)
    }
}

#Preview {
    AddTaskView(category: .birthday)
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
        CategoryPickerView(showPickerView: $viewModel.showCategories, category: $viewModel.category)
            .padding()
    }
    
    private var header: some View {
        HStack {
            Button {
                viewModel.nilButtonIsTapped()
                router.navigateBack()
                
            } label: {
                Image(systemName: Symbols.arrowLeft)
            }
            
            Spacer()
            
            Text(toDoToEdit == nil ? "Create a Task" : "Update a Task")
            
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

    private func parameters(for category: ToDoInterface.Category) -> (String, String?, String) {
        switch category {
        case .birthday:
            return ("Starting Party", "Ending Party", "List of guests")
        case .shoppingList:
            return ("Shopping Time", nil, "List of products")
        case .holidayEvent:
            return ("Starting Holiday", "Ending Holiday", "Holiday Description")
        case .medicalCheck:
            return ("Starting visit", nil, "Visit Description")
        case .trip:
            return ("Starting Trip", "Ending Trip", "Plan of a Trip")
        case .otherEvent:
            return ("Starting Event", "Ending Event", "Event Description")
        }
    }
    
    private var buildOverlayContent: some View {
        Rectangle()
            .fill(Colors.ghostWhite)
            .clipShape(.rect(topLeadingRadius: 40, topTrailingRadius: 40))
            .overlay {
                VStack {
                    if let selectedCategory = viewModel.category {
                        let (startTimeTitle, endTimeTitle, description) = parameters(for: selectedCategory)
                        CategoriesView(startTimeTitle: startTimeTitle, endTimeTitle: endTimeTitle, description: description, selectStartDate: $viewModel.selectStartTime, selectEndDate: $viewModel.selectEndTime, text: $viewModel.descriptionTextFieldText, numberOfNotifications: $viewModel.numberOfNotifications)
                    } else {
                        CategoriesView(selectStartDate: $viewModel.selectStartTime, selectEndDate: $viewModel.selectEndTime, text: $viewModel.descriptionTextFieldText, numberOfNotifications: $viewModel.numberOfNotifications)
                    }
                    
                    Spacer()
                    
                    ConfirmButton(title: toDoToEdit == nil ? "Create a Task" : "Update a Task") {
                        switch toDoToEdit {
                        case .none:
                            viewModel.addTask()
                        case .some:
                            viewModel.updateTask()
                        }
                        
                        router.navigateBack()
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
