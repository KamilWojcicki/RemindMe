//
//  CategoryPickerView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 18/05/2024.
//

import Design
import Navigation
import SwiftUI
import ToDoInterface

struct CategoryPickerView: View {
    
    @EnvironmentObject private var router: Router<Routes>
    @EnvironmentObject private var viewModel: TabBarViewModel
    @Binding var showPickerView: Bool
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    init(showPickerView: Binding<Bool>) {
        self._showPickerView = showPickerView
    }
    
    var body: some View {
        VStack(spacing: 0) {
            title
            
            LazyVGrid(columns: columns, spacing: 2) {
                categoriesButtons
            }
            .padding(10)
            
        }
        .background(Colors.blue.opacity(0.95))
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .shadow(color: Colors.night.opacity(0.6), radius: 10)
    }
}

#Preview {
    CategoryPickerView(showPickerView: .constant(true))
}

extension CategoryPickerView {
    private var title: some View {
        Text("Choose a category")
            .font(.system(size: 23, weight: .bold, design: .default))
            .foregroundStyle(Colors.ghostWhite)
            .padding()
    }
    
    private var categoriesButtons: some View {
        ForEach(Categories.allCases, id: \.self) { category in            
            Button {
                viewModel.toDoCategory = category
                showPickerView.toggle()
            } label: {
                VStack(alignment: .leading, spacing: 10) {
                    Image(systemName: category.image)
                    
                    Text(category.rawValue.capitalized)
                }
                .padding(.leading, 20)
                .frame(width: 160, height: 90, alignment: .leading)
                .background(Colors.ghostWhite)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .foregroundStyle(Colors.night)
                .font(.headline)
                .padding(8)
                .shadow(color: Colors.ghostWhite.opacity(0.8), radius: 5)
            }
        }
    }
}
