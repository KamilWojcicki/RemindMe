//
//  RemindMeApp.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 21/03/2024.
//

import SwiftUI
import Localizations

@main
struct RemindMeApp: App {
    
    @StateObject private var languageSettings = LanguageSetting()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear {
                    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path())
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
                .environmentObject(languageSettings)
                .environment(\.locale, languageSettings.locale)
        }
    }
}
