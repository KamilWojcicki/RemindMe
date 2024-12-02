//
//  File.swift
//  
//
//  Created by Kamil Wójcicki on 15/05/2024.
//

import Design
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
                ZStack {
                    if isPresented {
                        Colors.night.opacity(0.3).ignoresSafeArea()
                    }
                    view
                        .sheet(
                            isPresented: $isPresented,
                            onDismiss: onDismiss
                        ) {
                            ZStack(alignment: .top) {
                                destinationView
                                    .presentationDetents([presentationDetent])
                                    .presentationCornerRadius(35)
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                            .background(Colors.ghostWhite)
                            .ignoresSafeArea(edges: .bottom)
                        }
                        .blur(radius: isPresented ? 2 : 0)
                }
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
    public func withModal<Value: View>(_ type: ModalType, destinationView: Value, isPresented: Binding<Bool>, presentationDetent: PresentationDetent = .large, onDismiss: (() -> Void)? = nil) -> some View {
        modifier(ModalModifier(isPresented: isPresented, type: type, destinationView: destinationView, presentationDetent: presentationDetent, onDismiss: onDismiss))
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(ModalModifier(isPresented: .constant(true), type: .sheet, destinationView: PrevievView(), presentationDetent: .medium, onDismiss: { print("test") } ))
}


struct PrevievView: View {
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Rectangle()
                    .frame(width: 100, height: 200)
                Rectangle()
                    .frame(width: 100, height: 200)
                Rectangle()
                    .frame(width: 100, height: 200)
                Rectangle()
                    .frame(width: 100, height: 200)
                Rectangle()
                    .frame(width: 100, height: 200)
                Rectangle()
                    .frame(width: 100, height: 200)
            }
            .padding(.top)
        }
        
    }
}
