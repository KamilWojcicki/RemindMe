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
    private var currentLanguage: SupportedLanguage
    private var text: String
    @Binding var selectedLanguage: SupportedLanguage

    init(currentLanguage: SupportedLanguage, text: String, selectedLanguage: Binding<SupportedLanguage>) {
        self.currentLanguage = currentLanguage
        self.text = text
        self._selectedLanguage = selectedLanguage
    }
    
    var body: some View {
        Button {
            selectedLanguage = currentLanguage
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
    LanguageButton(currentLanguage: .english, text: "🇵🇱", selectedLanguage: .constant(.english))
}
