//
//  HomeView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import Components
import Design
import Navigation
import SwiftUI

public struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    public init() { }
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                
                Spacer()
                
                buildContent
                
                Spacer()
                
                Rectangle()
                    .fill(Colors.ghostWhite)
                    .clipShape(.rect(topLeadingRadius: 40, topTrailingRadius: 40))
                    .frame(height: geometry.size.height * 0.55)
                    .overlay {
                        buildOverlayContent
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

extension HomeView {
    @ViewBuilder
    private var buildContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Good Morning!")
                .font(.subheadline)
                .opacity(0.7)
            Text("Kamil Wójcicki 👋")
                .font(.title3)
        }
        .foregroundStyle(Colors.ghostWhite)
        .padding()
        
        TaskTile() { isEdited in
            viewModel.isEdited = isEdited
        }
        .padding()
    }
    
    private var buildOverlayContent: some View {
        VStack(alignment: .leading) {
            LazyVGrid(columns: columns,
                      spacing: 10,
                      content: {
                QuickTaskTile(
                    icon: Symbols.checklist,
                    title: "Shopping List",
                    description: "Create a shopping list"
                ) { }
                QuickTaskTile(
                    icon: Symbols.giftFill,
                    title: "Birthday",
                    description: "Add a birthday reminder") {
                        
                    }
                QuickTaskTile(
                    icon: Symbols.carFill,
                    title: "Trip",
                    description: "Add a trip reminder") {
                        
                    }
                QuickTaskTile(
                    icon: Symbols.crossCircleFill,
                    title: "Medical Check",
                    description: "Add a medical check reminder") {
                        
                    }
            })
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .padding()
    }
}

