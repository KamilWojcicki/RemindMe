//
//  AssemblyShared.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 08/04/2024.
//

import DependencyInjection
import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class public func setup() {
        Assemblies.setupDependencies()
    }
}
