//
//  OnboardingScreen.swift
//
//
//  Created by Kamil Wójcicki on 13/04/2024.
//

import SwiftUI

public struct OnboardingScreen: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding private var onboardingToggle: Bool
    
    public init(onboardingToggle: Binding<Bool>) {
        self._onboardingToggle = onboardingToggle
    }
    public var body: some View {
        TabView(selection: $viewModel.pageIndex) {
            ForEach(viewModel.pages) { page in
                VStack {
                    
                    if page == viewModel.pages.last {
                        Button("Get started") {
                            onboardingToggle = false
                        }
                    } else {
                        Button("Next") {
                            viewModel.incrementPage()
                        }
                    }
                }
                .tag(page.tag)
            }
        }
        .animation(.easeInOut, value: viewModel.pageIndex)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .onAppear {
            viewModel.dotAppearanceOnAppear()
        }
    }
}

#Preview {
    OnboardingScreen(onboardingToggle: .constant(true))
}
