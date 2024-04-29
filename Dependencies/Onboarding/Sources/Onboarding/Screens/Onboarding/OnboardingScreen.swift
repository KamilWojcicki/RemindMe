//
//  OnboardingScreen.swift
//
//
//  Created by Kamil Wójcicki on 13/04/2024.
//

import Animation
import Components
import SwiftUI
import Design

public struct OnboardingScreen: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding private var changeView: Bool
    
    public init(changeView: Binding<Bool>) {
        self._changeView = changeView
    }
    public var body: some View {
        GeometryReader { geometry in
            VStack {
                
                LottieView(animationConfiguration: .onboarding, loopMode: .loop)
                
                Spacer()
                
                Rectangle()
                    .fill(Colors.ghostWhite)
                    .clipShape(.rect(cornerRadius: 40))
                    .frame(height: geometry.size.height * 0.45)
                    .overlay {
                        VStack {
                            tabView
                            
                            onboardingButton
                        }
                    }
                    .offset(y: viewModel.animateRectangle ? geometry.size.height * 0.0 : geometry.size.height * 0.45)
            }
        }
        .ignoresSafeArea()
        .animation(.spring(duration: 0.6), value: viewModel.animateRectangle)
        .onAppear {
            viewModel.animateRectangle = true
        }
    }
}

#Preview {
    OnboardingScreen(changeView: .constant(true))
}

extension OnboardingScreen {
    @ViewBuilder
    private var tabView: some View {
        TabView(selection: $viewModel.pageIndex) {
            ForEach(viewModel.pages) { page in
                VStack {
                    //TODO: Add language option
                    Text(page.name)
                        .font(.title)
                        .bold()
                        .foregroundStyle(Colors.night)
                        .frame(maxHeight: 70, alignment: .top)
                    
                    Text(page.description)
                        .font(.subheadline)
                        .foregroundStyle(Colors.night)
                        .lineLimit(3)
                        .frame(maxHeight: 40, alignment: .top)
                }
                .padding()
                .tag(page.tag)
                .multilineTextAlignment(.center)
            }
        }
        .animation(.easeInOut, value: viewModel.pageIndex)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private var onboardingButton: some View {
        Button(title: viewModel.pageIndex == viewModel.pages.count - 1 ? "Get Started" : "Next") {
            viewModel.buttonPressed {
                withAnimation(.default) {
                    changeView.toggle()
                }
            }
        }
        .padding()
        .padding(.bottom, 40)
    }
}
