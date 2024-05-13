//
//  HistoryTab.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import SwiftUI

extension Tab {
    public static var history: Tab {
        Tab(
            title: "History",
            image: "archivebox",
            activeImage: "archivebox.fill",
            rootView: AnyView(HistoryView())
        )
    }
}
