//
//  Assembly.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 05/04/2024.
//

import DependencyInjection
import ToDo

extension Assemblies {
    static func setupDependencies() {
        ToDo.Dependencies.inject()
    }
}
