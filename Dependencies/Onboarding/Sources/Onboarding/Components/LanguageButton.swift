//
//  LanguageButton.swift
//
//
//  Created by Kamil Wójcicki on 10/05/2024.
//

import Design
import Localizations
import SwiftUI

struct LanguageButton: View {
    private var text: String
    let action: () -> Void

    init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
        }
        .shadow(
            color: Colors.night.opacity(0.55),
            radius: 10
        )
        .font(.largeTitle)
    }
}

#Preview {
    LanguageButton(text: "🇵🇱") {
        
    }
}
