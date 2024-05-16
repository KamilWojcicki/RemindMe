//
//  NavigationInterface.swift
//  
//
//  Created by Kamil Wójcicki on 15/05/2024.
//

import SwiftUI

public enum ModalType {
    case sheet
    case fullScreenCover
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
