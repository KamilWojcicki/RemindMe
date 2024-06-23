//
//  TabBarModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import ToDoInterface
import SwiftUI

public enum ModalType {
    case sheet
    case fullScreenCover
}

public struct Tab: Hashable {
    public let title: String
    public let image: String
    public let activeImage: String
    public let rootView: AnyView
    
    public init(
        title: String,
        image: String,
        activeImage: String,
        rootView: AnyView
    ) {
        self.title = title
        self.image = image
        self.activeImage = activeImage
        self.rootView = rootView
    }
    
    public static func == (lhs: Tab, rhs: Tab) -> Bool {
        lhs.title == rhs.title
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
