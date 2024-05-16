//
//  RouterView.swift
//
//
//  Created by Kamil Wójcicki on 15/05/2024.
//

import SwiftUI
import NavigationInterface

public struct RouterView<Root: View, Route: Routable>: View {
    @Binding private var routes: [Route]
    private let root: () -> Root

    public init(stack: Binding<[Route]>, @ViewBuilder root: @escaping () -> Root) {
        self._routes = stack
        self.root = root
    }

    public var body: some View {
        NavigationStack(path: $routes) {
            root()
                .navigationDestination(for: Route.self) { view in
                    view.body
                }
        }
    }
}
