//
//  HomeTab.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import SwiftUI

extension Tab {
    public static var home: Tab {
        Tab(
            title: "Home",
            image: "house",
            activeImage: "house.fill",
            rootView: AnyView(HomeView())
        )
    }
}
