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
    
    public static var size23DefaultBold: Font {
        return .system(size: 23, weight: .bold, design: .default)
    }
    
    public static var size23Default: Font {
        return .system(size: 23, design: .default)
    }
    
    public static var size18DefaultBold: Font {
        return .system(size: 18, weight: .bold, design: .default)
    }
    
    public static var size18Default: Font {
        return .system(size: 18, design: .default)
    }
    
    public static var size22Default: Font {
        return .system(size: 22, design: .default)
    }
}
