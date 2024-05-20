//
//  SwiftUIView.swift
//  
//
//  Created by Kamil Wójcicki on 18/05/2024.
//

import Design
import SwiftUI

public struct TextField: View {
    @Binding private var textFieldLogin: String
    
    public init(textFieldLogin: Binding<String>) {
        self._textFieldLogin = textFieldLogin
    }
    
    public var body: some View {
        VStack(spacing: 10) {
            SwiftUI.TextField("", text: $textFieldLogin)
                .font(.system(size: 23, weight: .bold, design: .default))
                .foregroundStyle(Colors.ghostWhite)
            
        }
    }
}

#Preview {
    ZStack {
        Colors.background().ignoresSafeArea()
        TextField(textFieldLogin: .constant(""))
    }

}
