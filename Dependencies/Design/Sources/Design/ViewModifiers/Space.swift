//
//  Space.swift
//  Design
//
//  Created by Kamil Wójcicki on 30/11/2024.
//

import Combine
import SwiftUI
import Utilities

class KeyboardSpace: ObservableObject {
    var sub: AnyCancellable?
    
    @Published var currentHeight: CGFloat = 0
    var heightIn: CGFloat = 0 {
        didSet {
            DispatchQueue.main.async {
                withAnimation {
                    if UIWindow.keyWindow != nil {
                        self.currentHeight = self.heightIn
                    }
                }
            }
        }
    }
    
    init() {
        subscribeToKeyboardEvents()
    }
    
    private let keyboardWillOpen = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect }
        .map { $0.height - (UIWindow.keyWindow?.safeAreaInsets.bottom ?? 0) }
    
    private let keyboardWillHide =  NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in CGFloat.zero }
    
    private func subscribeToKeyboardEvents() {
        sub?.cancel()
        sub = Publishers.Merge(keyboardWillOpen, keyboardWillHide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.self.heightIn, on: self)
    }
    
    deinit {
        sub?.cancel()
    }
}

let keyboardSpaceD = KeyboardSpace()

struct Space: ViewModifier {
    @ObservedObject var data: KeyboardSpace
    
    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
            
            Rectangle()
                .foregroundColor(Color(.clear))
                .frame(height: data.currentHeight)
                .frame(maxWidth: .greatestFiniteMagnitude)
                .padding(.top, -90)
        }
    }
}
public extension View {
    func keyboardSpace() -> some View {
        modifier(Space(data: keyboardSpaceD))
    }
}


