//
//  Assembly.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 05/04/2024.
//

import DependencyInjection
import Navigation

extension Assemblies {
    static func setupDependencies() {
        Navigation.Dependencies.inject()
    }
}
