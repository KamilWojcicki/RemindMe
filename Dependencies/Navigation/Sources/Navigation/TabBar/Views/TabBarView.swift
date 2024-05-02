//
//  TabBarView.swift
//
//
//  Created by Kamil Wójcicki on 08/04/2024.
//

import Design
import SwiftUI

//MARK: Create TabBarView
public struct TabBarView: View {
    @StateObject private var viewModel = TabBarViewModel()
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
        
        NavigationStack {
            ZStack(alignment: .bottom) {
                
                Colors.background().ignoresSafeArea()
                
                SwiftUI.TabView(selection: selectedTab) {
                    ForEach(viewModel.tabs, id: \.title) { tab in
                        tab.rootView
                    }
                }
                
                buildTabBarView
                    .padding(.vertical, 8)
                    .background(
                        .thickMaterial
                    )
                    .cornerRadius(40)
                    .padding(.horizontal)
            }
        }
        .navigationBarBackButtonHidden(true)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .never))
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
                            .font(.system(size: 20))
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
