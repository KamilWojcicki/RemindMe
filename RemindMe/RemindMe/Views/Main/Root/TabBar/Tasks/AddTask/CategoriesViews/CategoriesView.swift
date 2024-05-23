//
//  CategoriesView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 22/05/2024.
//

import Design
import SwiftUI
import Utilities

struct CategoriesView: View {
    @StateObject private var viewModel = CategoriesViewModel()
    
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
            StartEndDatePicker
            
            Divider()
            
            Text(description ?? "Description")
                .withOpacityFont()
            
            TextField("", text: $viewModel.text, axis: .vertical)
                .lineLimit(4...5)
                .font(.size23Default)
            
            Divider()
            
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
            
            Divider()
            
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
//        .tint(Colors.night)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CategoriesView(startTimeTitle: "Test", endTimeTitle: "Test End", description: "Desctiptoin")
}

extension CategoriesView {
    private var StartEndDatePicker: some View {
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
    }
}
