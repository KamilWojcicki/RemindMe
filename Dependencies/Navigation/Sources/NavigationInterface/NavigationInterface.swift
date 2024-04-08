//
//  NavigationInterface.swift
//  
//
//  Created by Kamil Wójcicki on 05/04/2024.
//

import SwiftUI

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

public protocol TabCoordinatorInterface {
    var tabs: [Tab] { get }
    var selectedTab: Tab? { get }
    func register(tab: Tab)
}

public protocol RoutableObject: AnyObject { 
    associatedtype Destination: Routable
    
    var stack: [Destination] { get set }
    
    func navigate(to destination: Destination)
    func navigate(to destinations: [Destination])
    func navigateBack()
    func navigateBack(_ count: Int)
    func navigateBack(to destination: Destination)
    func navigateToRoot()
    func replace(with destinations: [Destination])
}

public typealias Routable = View & Hashable
