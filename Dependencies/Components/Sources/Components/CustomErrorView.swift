//
//  CustomErrorView.swift
//  Components
//
//  Created by Kamil Wójcicki on 22/11/2024.
//

import Design
import SwiftUI

public struct CustomErrorView: View {
    
    let errorTitle: String = "There was an error"
    let message: String
    let action: () -> Void
    
    public init(message: String, action: @escaping () -> Void) {
        self.message = message
        self.action = action
    }
    
    public var body: some View {
        ZStack {
            Colors.night.opacity(0.3).ignoresSafeArea()
            
            VStack(spacing: 10) {
                Text(errorTitle)
                    .font(.size18DefaultBold)
                
                Text(message)
                    .font(.size15Default)
                
                ConfirmButton(title: "Try Again", role: .confirm) {
                    action()
                }
            }
            .padding()
            .background(Colors.ghostWhite)
            .foregroundStyle(Colors.night)
            .clipShape(.rect(cornerRadius: 20))
            .padding(.horizontal, 50)
        }
    }
}

#Preview {
    CustomErrorView(message: "Test") { }
}
