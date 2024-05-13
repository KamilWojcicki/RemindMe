//
//  OnboardingViewModel.swift
//
//
//  Created by Kamil Wójcicki on 13/04/2024.
//

import Design
import Foundation
import Localizations
import OnboardingInterface
import SwiftUI

final class OnboardingViewModel: ObservableObject {
    private let dotAppearance = UIPageControl.appearance()
    @Published var pageIndex = 0
    @Published var animateRectangle: Bool = false
    
    let pages: [Page] = Page.pages
    let page: Page = Page.samplePage
    
    private func incrementPage() {
        pageIndex += 1
    }
    
    func dotAppearanceOnAppear() {
        dotAppearance.currentPageIndicatorTintColor = UIColor(Colors.night)
        dotAppearance.pageIndicatorTintColor = UIColor(Colors.ghostWhite)
    }
    
    func buttonPressed(action: () -> Void) {
        if pageIndex == pages.count - 1 {
            action()
        } else {
            incrementPage()
        }
    }
}
