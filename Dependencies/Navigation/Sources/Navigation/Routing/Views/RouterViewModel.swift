//
//  RouterViewModel.swift
//
//
//  Created by Kamil Wójcicki on 05/04/2024.
//

import SwiftUI
import NavigationInterface

public final class Router<Routes: Routable>: RoutableObject, ObservableObject { 
    @Published public var stack: [Routes] = []
    
    public init() { }
}
