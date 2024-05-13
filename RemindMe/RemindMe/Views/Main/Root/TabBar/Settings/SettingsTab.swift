//
//  SettingsTab.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import SwiftUI

extension Tab {
    public static var settings: Tab {
        Tab(
            title: "Settings",
            image: "gearshape",
            activeImage: "gearshape.fill",
            rootView: AnyView(SettingsView())
        )
    }
}
