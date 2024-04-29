//
//  File.swift
//  
//
//  Created by Kamil Wójcicki on 29/04/2024.
//

import Foundation

public struct Configuration {
    public struct File {
        let filename: String
        let bundle: Bundle
        
        init(
            filename: String,
            bundle: Bundle
        ) {
            self.filename = filename
            self.bundle = bundle
        }
    }
    
    public let lightMode: File
    public let darkMode: File
    
    init(
        lightMode: File,
        darkMode: File
    ) {
        self.lightMode = lightMode
        self.darkMode = darkMode
    }
}

extension Configuration {
    public static let onboarding: Self = .init(
        lightMode: .init(
            filename: "onboarding_animation",
            bundle: .module
        ),
        darkMode: .init(
            filename: "onboarding_animation",
            bundle: .module
        )
    )
}


