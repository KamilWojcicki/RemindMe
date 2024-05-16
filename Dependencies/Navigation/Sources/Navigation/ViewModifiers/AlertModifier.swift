//
//  AlertModifier.swift
//
//
//  Created by Kamil Wójcicki on 15/05/2024.
//

import SwiftUI

public struct AlertViewModifier: ViewModifier {
    public enum `ButtonRole`: Hashable {
        var identifier: String {
            return UUID().uuidString
        }
        public static func == (lhs: AlertViewModifier.ButtonRole, rhs: AlertViewModifier.ButtonRole) -> Bool {
            return lhs.identifier == rhs.identifier
        }

        public func hash(into hasher: inout Hasher) {
            return hasher.combine(identifier)
        }

        case cancel(title: String, action: () -> ())
        case destructive(title: String, action: () -> ())
        case submit(title: String, action: () -> ())
    }

    @State private var textFieldText: String = ""
    @Binding private var errorToggle: Bool
    private let errorTitle: String
    private let message: String
    private let buttons: [`ButtonRole`]
    private var isTextfieldShown: Bool = false

    public init(buttons: [`ButtonRole`], errorTitle: String, errorToggle: Binding<Bool>, message: String, isTextfieldShown: Bool) {
        self.isTextfieldShown = isTextfieldShown
        self.buttons = buttons
        self.errorTitle = errorTitle
        self._errorToggle = errorToggle
        self.message = message
    }

    public func body(content: Content) -> some View {
        content
            .alert(errorTitle, isPresented: $errorToggle) {
                if isTextfieldShown {
                    TextField("write some text", text: $textFieldText)
                }
                buildMultipleButtons(with: buttons)
            } message: {
                Text(message)
            }
    }

    @ViewBuilder
    private func buildMultipleButtons(with buttons: [`ButtonRole`]) -> some View {
        ForEach(buttons, id: \.self) { button in
            switch button {
            case .cancel(let title, let action):
                Button(title, role: .cancel, action: action)
            case .destructive(let title, let action):
                Button(title, role: .destructive, action: action)
            case .submit(let title, let action):
                Button(title, role: .none, action: action)
            }
        }
    }
}

extension View {
    public func withAlert(errorTitle: String, errorToggle: Binding<Bool>, message: String, buttons: [AlertViewModifier.ButtonRole], isTextfieldShown: Bool = false) -> some View {
        modifier(AlertViewModifier(buttons: buttons, errorTitle: errorTitle, errorToggle: errorToggle, message: message, isTextfieldShown: isTextfieldShown))
    }
}
