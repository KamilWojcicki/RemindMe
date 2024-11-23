//
//  AlertModifier.swift
//
//
//  Created by Kamil Wójcicki on 15/05/2024.
//

import Components
import Design
import SwiftUI

public struct AlertViewModifier: ViewModifier {
    public enum SelectedButton: Hashable {
        var identifier: String {
            return UUID().uuidString
        }
        public static func == (lhs: SelectedButton, rhs: SelectedButton) -> Bool {
            return lhs.identifier == rhs.identifier
        }

        public func hash(into hasher: inout Hasher) {
            return hasher.combine(identifier)
        }

        case cancel(title: LocalizedStringKey, action: () -> ())
        case destructive(title: LocalizedStringKey, action: () -> ())
        case submit(title: LocalizedStringKey, action: () -> ())
    }

    @State private var textFieldText: String = ""
    @Binding private var errorToggle: Bool
    private let errorTitle: String
    private let message: String
    private let buttons: [SelectedButton]

    public init(errorTitle: String, message: String, errorToggle: Binding<Bool>, buttons: [SelectedButton]) {
        self.errorTitle = errorTitle
        self.message = message
        self._errorToggle = errorToggle
        self.buttons = buttons
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            
            if errorToggle {
                Colors.night.opacity(0.4).ignoresSafeArea()
                
                buildAlertView
                
            }
        }
    }
    
    private var buildAlertView: some View {
        VStack(spacing: 10) {
            Text(errorTitle)
                .font(.size18DefaultBold)
            Text(message)
                .font(.size15Default)
                .multilineTextAlignment(.center)
            
            buildMultipleButtons(with: buttons)
                .padding(.top, 20)
        }
        .frame(width: 250)
        .padding(30)
        .background(Colors.ghostWhite)
        .clipShape(.rect(cornerRadius: 20))
    }

    @ViewBuilder
    private func buildMultipleButtons(with buttons: [SelectedButton]) -> some View {
        ForEach(buttons, id: \.self) { button in
            switch button {
            case .cancel(let title, let action):
                ConfirmButton(title: title, role: .cancel, action: action)
            case .destructive(let title, let action):
                ConfirmButton(title: title, role: .destructive, action: action)
            case .submit(let title, let action):
                ConfirmButton(title: title, role: .confirm, action: action)
            }
        }
    }
}

extension View {
    public func withAlert(errorTitle: String, message: String, errorToggle: Binding<Bool>, buttons: [AlertViewModifier.SelectedButton]) -> some View {
        modifier(AlertViewModifier(errorTitle: errorTitle, message: message, errorToggle: errorToggle, buttons: buttons))
    }
}

#Preview {
    Text("Hello, world!")
        .withAlert(errorTitle: "Error", message: "This is a sample error with some text to debug", errorToggle: .constant(true), buttons: [.submit(title: "Submit", action: {}), .cancel(title: "Cancel", action: {})])
}
