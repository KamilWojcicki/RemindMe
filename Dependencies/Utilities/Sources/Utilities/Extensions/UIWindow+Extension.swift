//
//  File.swift
//  Utilities
//
//  Created by Kamil Wójcicki on 01/12/2024.
//

import SwiftUI

extension UIWindow {
    public static var keyWindow: UIWindow? {
        let keyWindow = UIApplication.shared.connectedScenes
            .first { $0.activationState == .foregroundActive }
            .flatMap { $0 as? UIWindowScene }?.windows
            .first { $0.isKeyWindow }
        return keyWindow
    }
}
