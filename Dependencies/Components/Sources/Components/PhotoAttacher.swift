//
//  PhotoAttacher.swift
//
//
//  Created by Kamil Wójcicki on 15/08/2024.
//

import Design
import PhotosUI
import SwiftUI

private enum LoadingImageState {
    case none
    case loading
    case loaded
}

public struct PhotoAttacher: View {
    @State private var isPhotoAttached: Bool = false
    @State private var state: LoadingImageState = .none
    @State private var progress: Double = 0.6
    @Binding private var defaultScrollAnchor: UnitPoint?
    @Binding private var photoAttacherHeight: CGFloat
    @Binding private var photoPickerSelection: PhotosPickerItem?
    
    public init(defaultScrollAnchor: Binding<UnitPoint?>, photoAttacherHeight: Binding<CGFloat>, photoPickerSelection: Binding<PhotosPickerItem?>) {
        self._defaultScrollAnchor = defaultScrollAnchor
        self._photoAttacherHeight = photoAttacherHeight
        self._photoPickerSelection = photoPickerSelection
    }
    
    public var body: some View {
        VStack {
            HStack(spacing: 20) {
                Symbols.paperclip
                Text("Attach photo")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            PhotosPicker(selection: $photoPickerSelection) {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Colors.vistaBlue.opacity(0.05))
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [9]))
                    .foregroundStyle(Colors.vistaBlue.opacity(0.5))
                    .overlay(alignment: .leading) {
                        HStack(spacing: 20) {
                            CircularIcon(icon: .trayIcon)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Click here")
                                    .font(.size18DefaultBold)
                                Text("Max photo size 20 MB")
                                    .font(.size15Default)
                            }
                            .tint(Colors.night)
                        }
                        .padding()
                    }
            }
            .onChange(of: photoPickerSelection) { _, _ in
                onChangeOfPhotoPickerSelection()
            }
            
            if isPhotoAttached {
                buildUploadedPhotosView()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: isPhotoAttached ? 235 : 120, alignment: .top)
        .padding()
        .background(Colors.ghostWhite)
        .clipShape(.rect(cornerRadius: 15))
        .shadow(radius: 10)
        .trackGeometry(position: $photoAttacherHeight)
    }
}

#Preview {
    PhotoAttacher(defaultScrollAnchor: .constant(.top), photoAttacherHeight: .constant(3), photoPickerSelection: .constant(.none))
}

extension PhotoAttacher {
    private func buildUploadedPhotosView() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Uploaded photos")
            
            HStack {
                CircularIcon(icon: .photoIcon)
                
                HStack {
                    Text(state == .loading ? "Uploading..." : "Uploaded")
                        .font(.size15Default)
                    
                    Spacer()
                    
                    switch state {
                    case .loading:
                        SwiftUI.ProgressView()
                    case .loaded:
                        Symbols.checkmarkSealFill
                            .foregroundStyle(Colors.mantis)
                    case .none:
                        EmptyView()
                    }
                }
                .padding(.horizontal, 10)
                
                Spacer()
                
                Button {
                    photoPickerSelection = .none
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            isPhotoAttached = false
                        }
                    }
                } label: {
                    Symbols.xmarkCircle
                        .tint(Colors.night)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 20)
    }
}

extension PhotoAttacher {
    @discardableResult
    private func onChangeOfPhotoPickerSelection() {
        defaultScrollAnchor = .bottom
        
        withAnimation {
            isPhotoAttached = true
        }
        
        state = .loading
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.state = .loaded
        }
    }
}
