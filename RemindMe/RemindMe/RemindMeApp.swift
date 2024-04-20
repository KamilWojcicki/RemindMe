//
//  RemindMeApp.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 21/03/2024.
//

import SwiftUI
import Root

@main
struct RemindMeApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .onAppear {
                    print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path())
                    UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
