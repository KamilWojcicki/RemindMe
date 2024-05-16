//
//  RouterViewModel.swift
//
//
//  Created by Kamil Wójcicki on 15/05/2024.
//

import Foundation
import NavigationInterface

public final class Router<Routes: Routable>: RoutableObject, ObservableObject {
    @Published public var stack: [Routes] = []

    public init() { }
}
