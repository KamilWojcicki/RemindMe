//
//  OnboardingInterface.swift
//  
//
//  Created by Kamil Wójcicki on 13/04/2024.
//

import SwiftUI

public struct Page: Identifiable, Equatable {
    public let id = UUID()
    public var name: String
    public var description: String
    public var tag: Int
    
    public static let samplePage: Page = Page(
        name: "Test page",
        description: "Test page description",
        tag: 0
    )
    
    public static let pages: [Page] = [
        Page(
            name: "Welcome to RemindMe",
            description: "Click NEXT or SLIDE screen to choose a language and learn more about app.",
            tag: 0
        ),
        Page(
            name: "Choose a prefer language to use",
            description: "You can change it later in settings.",
            tag: 1
        ),
        Page(
            name: "Create new task",
            description: "You can create a new task by clicking to plus button on Home Screen.",
            tag: 2
        ),
        Page(
            name: "Add notifications",
            description: "Add notifications which will remind you about your upcoming tasks by clicking to notification button.",
            tag: 3
        ),
        Page(
            name: "Well done",
            description: "That's all you need to know, let's get started!",
            tag: 4
        )
    ]
}
