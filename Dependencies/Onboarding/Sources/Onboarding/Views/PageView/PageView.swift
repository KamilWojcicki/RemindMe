//
//  PageView.swift
//
//
//  Created by Kamil Wójcicki on 27/04/2024.
//

import Design
import SwiftUI
import OnboardingInterface

struct PageView: View {
    
    private var page: Page = .samplePage
    @State private var animateRectangle: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                Rectangle()
                    .fill(Colors.ghostWhite)
                    .clipShape(.rect(cornerRadius: 40))
                    .frame(height: animateRectangle ? geometry.size.height * 0.45 : geometry.size.height * 0)
                    .overlay {
                        VStack(spacing: 20) {
                            Text(page.name)
                                .font(.title)
                                .bold()
                                .foregroundStyle(animateRectangle ? Colors.night : Colors.night.opacity(0))
                            
                            Text(page.description)
                                .font(.subheadline)
                        }
                        
                    }
                    
            }
        }
        .ignoresSafeArea()
        .animation(.spring, value: animateRectangle)
        .onAppear {
            animateRectangle = true
        }
    }
}

#Preview {
    
    ZStack {
        Colors.background().ignoresSafeArea()
        
        PageView()
    }
    
}
