//
//  RootView.swift
//
//
//  Created by Kamil Wójcicki on 13/04/2024.
//

import SwiftUI
import Onboarding
import Navigation

public struct RootView: View {
    @State private var isFirstAppear: Bool = true
    
    public init() { }
    
    public var body: some View {
        ZStack {
//            lepsze niż to będzie coś w stylu jeśli nie ma użytkownika w bazie to uruchom OnboardingScreen, jeśli użytkownik istnieje już w bazie to znaczy że pierwszy raz uruchamiał już aplikację więc przejdź do TabBarView
            if isFirstAppear {
                OnboardingScreen(onboardingToggle: $isFirstAppear)
            } else {
               TabBarView()
            }
        }
    }
}

#Preview {
    RootView()
}
