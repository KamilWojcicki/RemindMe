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
                    .padding(5)
                    .padding(.vertical, 3)
                    .background(
                        .regularMaterial
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
                
                Image(systemName: isSelectedTab ? tab.activeImage : tab.image)
                    .font(.title2)
                    .scaleEffect(isSelectedTab ? 1.3 : 1.0)
                    .foregroundStyle(isSelectedTab ? Colors.ghostWhite : Color.gray)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .padding(5)
                    .background(
                        ZStack {
                            if isSelectedTab {
                                Circle()
                                    .fill(Colors.blue)
                                    .matchedGeometryEffect(id: "background_circle", in: namespace)
                            }
                        }
                    )
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
