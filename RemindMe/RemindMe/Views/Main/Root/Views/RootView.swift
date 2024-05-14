//
//  RootView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import Design
import SwiftUI

public struct RootView: View {
    @AppStorage("isFirstAppear") var isFirstAppear: Bool = true
    
    public init() { }
    
    public var body: some View {
        ZStack {
            Colors.background().ignoresSafeArea()
            
            if isFirstAppear {
                OnboardingScreen(changeView: $isFirstAppear)
            } else {
               TabBarView()
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            }
        }
    }
}

#Preview {
    RootView()
}

