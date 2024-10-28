//
//  OnboardingScreen.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import Animation
import Components
import Design
import Localizations
import SwiftUI


public struct OnboardingScreen: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding private var changeView: Bool
    @EnvironmentObject private var languageSetting: LanguageSetting
    
    public init(changeView: Binding<Bool>) {
        self._changeView = changeView
    }
    public var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                skipButton
                
                LottieView(animationConfiguration: .onboarding, loopMode: .loop)
                
                BottomSheet(isPresented: $viewModel.animateRectangle) {
                    VStack {
                        pageView
                        
                        onboardingButton
                    }
                }
                .transition(.move(edge: .bottom))
            }
        }
        .onAppear {
            withAnimation {
                viewModel.animateRectangle = true
            }
            
        }
    }
}

#Preview {
    ZStack {
        Colors.background().ignoresSafeArea()
        OnboardingScreen(changeView: .constant(true))
    }
    
}

extension OnboardingScreen {
    @ViewBuilder
    private var pageView: some View {
        TabView(selection: $viewModel.pageIndex) {
            ForEach(viewModel.pages) { page in
                VStack(spacing: 30) {
                    Text(page.name)
                        .font(.title)
                        .bold()
                        .foregroundStyle(Colors.night)
                        .frame(maxHeight: 70, alignment: .top)
                    
                    Text(page.description)
                        .font(.subheadline)
                        .foregroundStyle(Colors.night)
                        .lineLimit(3)
                    
                    if page.name == "onboarding_prefer_language_title".localized {
                        languageButtons
                    }
                }
                .frame(height: 200, alignment: .top)
                .padding(.horizontal)
                .tag(page.tag)
                .multilineTextAlignment(.center)
            }
        }
        .animation(.easeInOut, value: viewModel.pageIndex)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private var onboardingButton: some View {
        ConfirmButton(title: viewModel.pageIndex == viewModel.pages.count - 1 ? "onboarding_get_started_button".localized : "onboarding_next_button".localized, role: .confirm) {
            viewModel.buttonPressed {
                withAnimation(.spring) {
                    changeView.toggle()
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 40)
    }
    
    private var languageButtons: some View {
        HStack(spacing: 100) {
            LanguageButton(
                text: "🇵🇱") {
                    languageSetting.setLocale(language: .polish)
                }
            
            LanguageButton(
                text: "🇺🇸") {
                    languageSetting.setLocale(language: .english)
                }
        }
    }
    
    private var skipButton: some View {
        Button("Skip") {
            viewModel.skipPages()
        }
        .foregroundStyle(Colors.ghostWhite)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.horizontal, 20)
    }
}
