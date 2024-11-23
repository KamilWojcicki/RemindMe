//
//  CustomProgressView.swift
//  Components
//
//  Created by Kamil Wójcicki on 18/10/2024.
//

import Design
import SwiftUI

public struct CustomProgressView: View {
    
    private let message: String
    private let background: Color?
    
    public init(message: String, background: Color? = Colors.night.opacity(0.4)) {
        self.message = message
        self.background = background
    }
    
    public var body: some View {
        ZStack {
            background.ignoresSafeArea()
            
            VStack {
                Text(message)
                    .font(.size15DefaultBold)
                
                ProgressView()
                    .padding()
                    .shadow(radius: 10)
            }
            .padding()
            .padding(.horizontal)
            .background(Colors.ghostWhite)
            .clipShape(.rect(cornerRadius: 20))
        }
    }
}

#Preview {
    CustomProgressView(message: "Loading")
}
