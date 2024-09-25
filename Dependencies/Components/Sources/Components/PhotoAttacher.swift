//
//  PhotoAttacher.swift
//
//
//  Created by Kamil Wójcicki on 15/08/2024.
//

import Design
import SwiftUI

public struct PhotoAttacher: View {
    private let action: () -> Void
    private let deletePhotoAction: () -> Void
    @State var isPhotoAttached: Bool = false
    @State private var progress: Double = 1.0
    @Binding private var defaultScrollAnchor: UnitPoint?
    
    public init(defaultScrollAnchor: Binding<UnitPoint?>, action: @escaping () -> Void, deletePhotoAction: @escaping () -> Void) {
        self._defaultScrollAnchor = defaultScrollAnchor
        self.action = action
        self.deletePhotoAction = deletePhotoAction
    }
    
    public var body: some View {
        VStack {
            HStack(spacing: 20) {
                Symbols.paperclip
                Text("Attach photo")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            RoundedRectangle(cornerRadius: 25)
                .fill(Colors.vistaBlue.opacity(0.05))
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [9]))
                .foregroundStyle(Colors.vistaBlue.opacity(0.5))
                .overlay(alignment: .leading) {
                    HStack(spacing: 20) {
                        CircularIcon(icon: .trayIcon)
                        #warning("the same stuf, image should be in a circle and it should be a static image.")
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Click here")
                                .font(.size18DefaultBold)
                            Text("Max photo size 20 MB")
                                .font(.size15Default)
                        }
                    }
                    .padding()
                }
                .frame(maxHeight: 80)
                .onTapGesture {
                    action()
                    defaultScrollAnchor = .bottom
                    withAnimation {
                        isPhotoAttached.toggle()
                    }
                }
            
            if isPhotoAttached {
                buildUploadedPhotosView()

            }                
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: isPhotoAttached ? 200 : 120, alignment: .top)
        .padding()
        
        .background(Colors.ghostWhite)
        .clipShape(.rect(cornerRadius: 15))
        .shadow(radius: 10)
    }
}

#Preview {
    PhotoAttacher(defaultScrollAnchor: .constant(.top)) {
        
    } deletePhotoAction: {
        
    }
}

extension PhotoAttacher {
    private func buildUploadedPhotosView() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Uploaded photos")
            
            HStack {
                Image(systemName: "photo.badge.plus")
                
                if progress != 1.0 {
                    VStack(alignment: .leading) {
                        Text("Uploading...")
                            .font(.size15Default)
                        
                        ProgressView(value: progress)
                        
                    }
                    .padding(.horizontal, 10)
                }
                
                Spacer()
                
                Button {
                    deletePhotoAction()
                    withAnimation {
                        isPhotoAttached.toggle()
                    }
                } label: {
                    Image(systemName: "xmark.circle")
                        .tint(Colors.night)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 20)
    }
}
