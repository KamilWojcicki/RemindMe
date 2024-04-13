//
//  OnboardingViewModel.swift
//
//
//  Created by Kamil Wójcicki on 13/04/2024.
//

import Foundation
import OnboardingInterface
import SwiftUI

final class OnboardingViewModel: ObservableObject {
    private let dotAppearance = UIPageControl.appearance()
    @Published var pageIndex = 0
    
    let pages: [Page] = Page.pages
    
    
    func incrementPage() {
        pageIndex += 1
    }
    
    func dotAppearanceOnAppear() {
        dotAppearance.currentPageIndicatorTintColor = .black
        dotAppearance.pageIndicatorTintColor = .lightGray
    }
}
