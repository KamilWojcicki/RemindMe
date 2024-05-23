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
        VStack {
            skipButton
            
            LottieView(animationConfiguration: .onboarding, loopMode: .loop)
            
            GeometryReader { geometry in
                Rectangle()
                    .fill(Colors.ghostWhite)
                    .clipShape(.rect(cornerRadius: 40))
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .shadow(color: Colors.night.opacity(0.4), radius: 10, y: -5)
                    .overlay {
                        VStack {
                            pageView
                            
                            onboardingButton
                        }
                    }
                    
                    .offset(y: viewModel.animateRectangle ? geometry.size.height * 0.0 : geometry.size.height * 1)
            }
            .ignoresSafeArea()
            .animation(.spring(duration: 0.6), value: viewModel.animateRectangle)
            .onAppear {
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
                VStack(spacing: 20) {
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
                .padding(.top, 60)
                .padding()
                .tag(page.tag)
                .multilineTextAlignment(.center)
            }
        }
        .animation(.easeInOut, value: viewModel.pageIndex)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private var onboardingButton: some View {
        ConfirmButton(title: viewModel.pageIndex == viewModel.pages.count - 1 ? "onboarding_get_started_button".localized : "onboarding_next_button".localized) {
            viewModel.buttonPressed {
                withAnimation(.spring) {
                    changeView.toggle()
                }
            }
        }
        .padding()
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
