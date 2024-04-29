//
//  RootView.swift
//
//
//  Created by Kamil Wójcicki on 13/04/2024.
//

import Design
import SwiftUI
import Onboarding
import Navigation

public struct RootView: View {
    @State private var isFirstAppear: Bool = true
    
    public init() { }
    
    public var body: some View {
        ZStack {
            Colors.background().ignoresSafeArea()
            
            if isFirstAppear {
                OnboardingScreen(changeView: $isFirstAppear)
            } else {
               TabBarView()
                    .transition(.move(edge: .trailing))
            }
        }
    }
}

#Preview {
    RootView()
}
