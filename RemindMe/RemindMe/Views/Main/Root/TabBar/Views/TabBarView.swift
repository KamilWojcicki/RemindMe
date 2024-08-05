//
//  TabBarView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import Design
import Navigation
import SwiftUI

public struct TabBarView: View {
    @StateObject private var viewModel = TabBarViewModel()
    @StateObject private var router = Router<Routes>()
    @Namespace private var namespace
    
    public init() {
        UITabBar.appearance().isHidden = true
    }
    
    public var body: some View {
        let selectedTab = Binding {
            self.viewModel.selectedTab ?? ""
        } set: {
            self.viewModel.selectedTab = $0
        }
        
        NavigationStack(path: $router.stack) {
            ZStack(alignment: .bottom) {
                Colors.ghostWhite.ignoresSafeArea()
                
                VStack {
                    SwiftUI.TabView(selection: selectedTab) {
                        ForEach(viewModel.tabs, id: \.title) { tab in
                            ZStack {
                                Colors.ghostWhite
                                Colors.background()
                                    .clipShape(.rect(bottomLeadingRadius: 45, bottomTrailingRadius: 45))
                                    .ignoresSafeArea()
                                    
                                tab.rootView
                                    .clipShape(.rect(bottomLeadingRadius: 45, bottomTrailingRadius: 45))
                            }
                        }
                    }
                    .ignoresSafeArea()
                    
                    buildTabBarView
                }
            }
            .navigationDestination(for: Routes.self) { path in
                switch path {
                case .addTask(let task): AddTaskView(toDoToEdit: task, category: viewModel.category)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        .environmentObject(router)
    }
}

extension TabBarView {
    private var buildTabBarView: some View {
        HStack {
            ForEach(viewModel.tabs, id: \.title) { tab in
                let isSelectedTab = viewModel.selectedTab == tab.title
                
                Spacer()

                VStack(spacing: 7) {
                    Image(systemName: isSelectedTab ? tab.activeImage : tab.image)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        
                    Text(tab.title)
                        .font(.system(size: 14))
                }
                .foregroundStyle(isSelectedTab ? Colors.blue : Colors.night.opacity(0.7))
                .padding(.horizontal)
                .padding(.top)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.tapped(tab: tab.title)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    TabBarView()
}
