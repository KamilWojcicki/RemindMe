//
//  File.swift
//  
//
//  Created by Kamil Wójcicki on 15/05/2024.
//

import SwiftUI
import NavigationInterface

struct ModalModifier<Value: View>: ViewModifier {
    @Binding var isPresented: Bool
    let type: ModalType
    let destinationView: Value
    let presentationDetent: PresentationDetent
    let onDismiss: (() -> ())?
    
    func body(content: Content) -> some View {
        content
            .if(type == .sheet) { view in
                view
                    .sheet(
                        isPresented: $isPresented,
                        onDismiss: onDismiss
                    ) {
                        destinationView
                            .presentationDetents([presentationDetent])
                    }
                    .blur(radius: isPresented ? 2 : 0)
            }
            .if(type == .fullScreenCover) { view in
                view
                    .fullScreenCover(
                        isPresented: $isPresented,
                        onDismiss: onDismiss
                    ) {
                        destinationView
                    }
            }
    }
}

extension View {
    public func withModal<Value: View>(_ type: ModalType, destinationView: Value, isPresented: Binding<Bool>, presentationDetent: PresentationDetent, onDismiss: (() -> Void)? = nil) -> some View {
        modifier(ModalModifier(isPresented: isPresented, type: type, destinationView: destinationView, presentationDetent: presentationDetent, onDismiss: onDismiss))
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(ModalModifier(isPresented: .constant(true), type: .sheet, destinationView: Text("test"), presentationDetent: .medium, onDismiss: { print("test") } ))
}
