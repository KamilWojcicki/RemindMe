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
    
    public init(message: String) {
        self.message = message
    }
    
    public var body: some View {
        ZStack {
            Colors.night.opacity(0.4).ignoresSafeArea()
            
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
