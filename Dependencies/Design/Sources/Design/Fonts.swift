//
//  File.swift
//  
//
//  Created by Kamil Wójcicki on 23/05/2024.
//

import Foundation
import SwiftUI

extension Font {
    public static var size15Default: Font {
        return .system(size: 15).weight(.regular)
    }
    
    public static var size23Default: Font {
        return .system(size: 23, weight: .bold, design: .default)
    }
}
