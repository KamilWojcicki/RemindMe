//
//  Assembly.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 05/04/2024.
//

import DependencyInjection
import Root

extension Assemblies {
    static func setupDependencies() {
        Root.Dependencies.inject()
    }
}
