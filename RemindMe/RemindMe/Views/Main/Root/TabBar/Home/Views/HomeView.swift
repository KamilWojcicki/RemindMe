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

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var router: Router<Routes>
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                buildContent
                GeometryReader { geometry in
                    whiteSpace(height: geometry.size.height)
                        .padding(.top, 30)
                }
                .ignoresSafeArea()
            }
        }
        .task {
            viewModel.getLatestTask()
            viewModel.isEdited = false
            viewModel.archiveExpiredToDo()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
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
        .foregroundStyle(Colors.night)
        .padding()
        
        TaskTile(
            latestTask: $viewModel.latestToDo,
            isDone: $viewModel.isDone,
            isEdited: $viewModel.isEdited
        ) { buttonType in
            try await viewModel.buttonTapped(buttonType)
        }
        .padding()
    }
    
    private func whiteSpace(height: CGFloat) -> some View {
        Rectangle()
            .fill(Colors.ghostWhite)
            .clipShape(.rect(topLeadingRadius: 40, topTrailingRadius: 40))
            .frame(maxHeight: .infinity, alignment: .bottom)
            .shadow(color: Colors.night.opacity(0.4), radius: 10, y: -5)
            .overlay {
                buildOverlayContent
            }
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
                ) {
                    viewModel.updateToDoCategory(to: .shoppingList)
                    router.navigate(to: .addTask())
                }
                QuickTaskTile(
                    icon: Symbols.giftFill,
                    title: "Birthday",
                    description: "Add a birthday reminder"
                ) {
                    viewModel.updateToDoCategory(to: .birthday)
                    router.navigate(to: .addTask())
                }
                QuickTaskTile(
                    icon: Symbols.carFill,
                    title: "Trip",
                    description: "Add a trip reminder"
                ) {
                    viewModel.updateToDoCategory(to: .trip)
                    router.navigate(to: .addTask())
                }
                QuickTaskTile(
                    icon: Symbols.crossCircleFill,
                    title: "Medical Check",
                    description: "Add a medical check reminder"
                ) {
                    viewModel.updateToDoCategory(to: .medicalCheck)
                    router.navigate(to: .addTask())
                }
            })
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .padding()
    }
}

