//
//  RootView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import Design
import SwiftUI

struct RootView: View {
    @StateObject private var viewModel = RootViewModel()
    
    var body: some View {
        ZStack {
            Colors.background().ignoresSafeArea()
            
            if viewModel.isFirstAppear {
                OnboardingScreen(changeView: $viewModel.isFirstAppear)
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

