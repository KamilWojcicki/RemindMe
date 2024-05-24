//
//  CategoriesView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 22/05/2024.
//

import Components
import Design
import SwiftUI
import Utilities

private enum Field {
    case description
}

struct CategoriesView: View {
    @StateObject private var viewModel = CategoriesViewModel()
    @FocusState private var isFocused: Field?
    private var startTimeTitle: String?
    private var endTimeTitle: String?
    private var description: String?
    
    init(startTimeTitle: String? = "Start Time", endTimeTitle: String? = nil, description: String? = "Description") {
        self.startTimeTitle = startTimeTitle
        self.endTimeTitle = endTimeTitle
        self.description = description
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            startEndDatePicker
            
            descriptionField
            
            numbersOfNotifications
            
            periodicNotifications
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CategoriesView(startTimeTitle: "Test", endTimeTitle: "Test End", description: "Desctiptoin")
}

extension CategoriesView {
    @ViewBuilder
    private var startEndDatePicker: some View {
        HStack(spacing: 60) {
            VStack(alignment: .leading, spacing: 13) {
                Text(startTimeTitle ?? "Start Time")
                    .withOpacityFont()
                
                Text(dateFormatter(dateFormat: .time).string(from: viewModel.selectStartDate))
                    .foregroundStyle(Colors.night)
                    .overlay {
                        DatePicker(
                            "",
                            selection: $viewModel.selectStartDate,
                            in: Date()...,
                            displayedComponents: .hourAndMinute
                        )
                        .blendMode(.destinationOut)
                        .labelsHidden()
                    }
                    .font(.size23Default)
            }
            
            if let endTimeTitle = endTimeTitle {
                VStack(alignment: .leading, spacing: 13) {
                    Text(endTimeTitle)
                        .withOpacityFont()
                    
                    Text(dateFormatter(dateFormat: .time).string(from: viewModel.selectEndDate))
                        .foregroundStyle(Colors.night)
                        .overlay {
                            DatePicker(
                                "",
                                selection: $viewModel.selectEndDate,
                                in: Date()...,
                                displayedComponents: .hourAndMinute
                            )
                            .labelsHidden()
                            .blendMode(.destinationOut)
                        }
                        .font(.size23Default)
                }
            }
        }
        
        OpacityDivider()
    }
        
    @ViewBuilder
    private var descriptionField: some View {
        Text(description ?? "Description")
            .withOpacityFont()
        
        TextField("", text: $viewModel.text, axis: .vertical)
            .lineLimit(4...5)
            .font(.size23Default)
            .focused($isFocused, equals: .description)
            .toolbar {
                if isFocused == .description {
                    ToolbarItemGroup(placement: .keyboard) {
                        
                        Spacer()
                        
                        Button("Done") {
                            isFocused = nil
                        }
                    }
                }
            }
        OpacityDivider()
    }
    
    @ViewBuilder
    private var numbersOfNotifications: some View {
        Text("Numbers of notifications")
            .withOpacityFont()
        
        Menu {
            Picker("", selection: $viewModel.numberOfNotifications) {
                ForEach(1..<10) { value in
                    Text(value.description)
                        .tag(value)
                        .font(.size23Default)
                }
            }
        } label: {
            Text(viewModel.numberOfNotifications.description)
                .font(.size23Default)
        }
        .tint(Colors.night)
        
        OpacityDivider()
    }
    
    @ViewBuilder
    private var periodicNotifications: some View {
        Text("Periodic notifications")
            .withOpacityFont()
        
        HStack {
            Toggle("test", isOn: $viewModel.isOn)
                .labelsHidden()
            
            if viewModel.isOn {
                Menu {
                    Picker("", selection: $viewModel.period) {
                        ForEach(Period.allCases, id: \.self) { period in
                            Text(period.rawValue)
                                .tag(period)
                                .font(.size23Default)
                        }
                    }
                } label: {
                    Text(viewModel.period.rawValue)
                        .font(.size23Default)
                }
                .tint(Colors.night)
            }
        }
    }
}
