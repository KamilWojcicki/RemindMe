//
//  RootView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import Design
import SwiftUI

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

