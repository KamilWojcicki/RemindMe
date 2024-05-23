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
    @EnvironmentObject private var router: Router<Routes>
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject private var secViewModel: TabBarViewModel
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
                ) {
                    viewModel.updateToDoCategory(to: .shoppingList, using: secViewModel)
                    router.navigate(to: .addTask)
                }
                QuickTaskTile(
                    icon: Symbols.giftFill,
                    title: "Birthday",
                    description: "Add a birthday reminder"
                ) {
                    viewModel.updateToDoCategory(to: .birthday, using: secViewModel)
                    router.navigate(to: .addTask)
                }
                QuickTaskTile(
                    icon: Symbols.carFill,
                    title: "Trip",
                    description: "Add a trip reminder"
                ) {
                    viewModel.updateToDoCategory(to: .trip, using: secViewModel)
                    router.navigate(to: .addTask)
                }
                QuickTaskTile(
                    icon: Symbols.crossCircleFill,
                    title: "Medical Check",
                    description: "Add a medical check reminder"
                ) {
                    viewModel.updateToDoCategory(to: .medicalCheck, using: secViewModel)
                    router.navigate(to: .addTask)
                }
            })
            .frame(maxHeight: .infinity, alignment: .top)
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
}

