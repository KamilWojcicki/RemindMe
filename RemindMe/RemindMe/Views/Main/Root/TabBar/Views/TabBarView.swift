//
//  TabBarView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import Design
import Navigation
import SwiftUI

//MARK: Create TabBarView
public struct TabBarView: View {
    @StateObject private var viewModel = TabBarViewModel()
    @StateObject private var router: Router<Routes> = .init()
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
        
        RouterView(stack: $router.stack) {
            ZStack(alignment: .bottom) {
                
                Colors.background().ignoresSafeArea()
                
                SwiftUI.TabView(selection: selectedTab) {
                    ForEach(viewModel.tabs, id: \.title) { tab in
                        tab.rootView
                            
                            
                    }
                }
                .ignoresSafeArea()
                
                buildTabBarView
                    .padding(.vertical, 8)
                    .background(
                        Colors.ghostWhite
                    )
                    .cornerRadius(40)
                    .shadow(
                        color: Colors.night.opacity(0.3),
                        radius: 10
                    )
                    .padding(.horizontal)
                    
            }
        }
        .environmentObject(viewModel)
        .environmentObject(router)
        .navigationBarBackButtonHidden(true)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

extension TabBarView {
    private var buildTabBarView: some View {
        HStack {
            ForEach(viewModel.tabs, id: \.title) { tab in
                let isSelectedTab = viewModel.selectedTab == tab.title
                
                Spacer()

                HStack {
                    Spacer()
                    
                    Image(systemName: isSelectedTab ? tab.activeImage : tab.image)
                        .resizable()
                        .renderingMode(.template)
                        
                        .frame(width: 20, height: 20)
                    if isSelectedTab {
                        Text(tab.title)
                            .font(.system(size: 16))
                    }
                    
                    Spacer()
                }
                .frame(width: isSelectedTab ? nil : 60, height: 60)
                .background(isSelectedTab ? Colors.blue.opacity(0.85) : .clear)
                .cornerRadius(40)
                .foregroundColor(isSelectedTab ? Colors.ghostWhite : Colors.night.opacity(0.5))
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
