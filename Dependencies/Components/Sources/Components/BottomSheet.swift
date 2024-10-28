//
//  BottomSheet.swift
//  Components
//
//  Created by Kamil Wójcicki on 10/10/2024.
//

import Design
import SwiftUI

public struct BottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    
    public init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }
    
    public var body: some View {
        if isPresented {
            VStack {
                Spacer()
                
                VStack {
                    content
                }
                .frame(maxWidth: .infinity)
                .background(Colors.ghostWhite)
                .clipShape(.rect(cornerRadius: 40))
                .shadow(color: Colors.night.opacity(0.4), radius: 10, y: -5)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

#Preview {
    BottomSheet(isPresented: .constant(true)) {
        VStack {
            Text("dupa")
        }
        .background(.red)
    }
}
