//
//  OnboardingModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/05/2024.
//

import Localizations
import SwiftUI

public struct Page: Identifiable, Equatable {
    public let id = UUID()
    public var name: LocalizedStringKey
    public var description: LocalizedStringKey
    public var tag: Int
    
    public static let samplePage: Page = Page(
        name: "Test page",
        description: "Test page description",
        tag: 0
    )
    
    public static let pages: [Page] = [
        Page(
            name: "onboarding_welcome_title".localized,
            description: "onboarding_welcome_description".localized,
            tag: 0
        ),
        Page(
            name: "onboarding_prefer_language_title".localized,
            description: "onboarding_prefer_language_description".localized,
            tag: 1
        ),
        Page(
            name: "onboarding_create_new_task_title".localized,
            description: "onboarding_create_new_task_description".localized,
            tag: 2
        ),
        Page(
            name: "onboarding_add_notification_title".localized,
            description: "onboarding_add_notification_description".localized,
            tag: 3
        ),
        Page(
            name: "onboarding_well_done_title".localized,
            description: "onboarding_well_done_description".localized,
            tag: 4
        )
    ]
}
