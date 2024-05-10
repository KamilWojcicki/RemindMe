//
//  HomeView.swift
//
//
//  Created by Kamil Wójcicki on 01/05/2024.
//

import Design
import SwiftUI

public struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    public init() { }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Good Morning!")
                        .font(.subheadline)
                        .opacity(0.7)
                    Text("Kamil Wójcicki 👋")
                        .font(.title3)
                }
                .foregroundStyle(Colors.ghostWhite)
                .padding()
                
                TaskTile(category: "Test", title: "Test") { isEdited in
                    viewModel.isEdited = isEdited
                }
                .padding()
                
                Spacer()
                
                Rectangle()
                    .fill(Colors.ghostWhite)
                    .clipShape(.rect(cornerRadius: 40))
                    .frame(height: geometry.size.height * 0.55)
                    .overlay {

                    }
            }
            .padding(.top, 30)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ZStack {
        Colors.background().ignoresSafeArea()
        HomeView()
    }
    
}
