//
//  FullImageView.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 20/11/2024.
//

import Design
import SwiftUI

struct FullImageView: View {
    @Binding var isPresented: Bool
    let image: Data?
    
    var body: some View {
        if let uiImage = UIImage(data: image ?? Data()) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(40)
                
                .onTapGesture {
                    withAnimation {
                        isPresented.toggle()
                    }
                    
                }
        }
    }
}

#Preview {
    FullImageView(isPresented: .constant(true), image: Data())
}
