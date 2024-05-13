//
//  TasksTab.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import SwiftUI

extension Tab {
    public static var tasks: Tab {
        Tab(
            title: "Tasks",
            image: "checkmark.circle",
            activeImage: "checkmark.circle.fill",
            rootView: AnyView(TasksView())
        )
    }
}
