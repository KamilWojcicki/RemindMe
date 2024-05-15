//
//  QuickTaskTile.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 14/05/2024.
//

import Design
import SwiftUI

struct QuickTaskTile: View {
    
    let icon: String
    let title: LocalizedStringKey
    let description: LocalizedStringKey
    let action: () -> Void
    
    init(icon: String = "pencil.and.scribble", title: LocalizedStringKey = "Title", description: LocalizedStringKey = "Description", action: @escaping () -> Void) {
        self.icon = icon
        self.title = title
        self.description = description
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading, spacing: 30) {
                Image(systemName: icon)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.caption).opacity(0.8)
                    
                    Text(description)
                        .font(.headline)
                }
                .multilineTextAlignment(.leading)
            }
            .padding(5)
            .foregroundStyle(Colors.ghostWhite)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Colors.vistaBlue)
        .clipShape(.rect(cornerRadius: 40))
        .shadow(color: Colors.vistaBlue, radius: 5)
    }
}

#Preview {
    ZStack {
        QuickTaskTile() { }
    }
    
}
