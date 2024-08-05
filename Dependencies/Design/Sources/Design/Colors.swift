//
//  Colors.swift
//
//
//  Created by Kamil Wójcicki on 13/04/2024.
//

import SwiftUI

public struct Colors {
    public static let blue = Color("Blue", bundle: .module)
    
    public static let ghostWhite = Color("GhostWhite", bundle: .module)
    
    public static let imperialRed = Color("ImperialRed", bundle: .module)
    
    public static let mantis = Color("Mantis", bundle: .module)

    public static let vistaBlue = Color("VistaBlue", bundle: .module)
    
    public static let night = Color("Night", bundle: .module)
    
    public static let color1 = Color("Color 1", bundle: .module)
    
    public static let color2 = Color("Color 2", bundle: .module)
    
    public static let color = Color("Color", bundle: .module)
    
    public static let background = {
        LinearGradient(colors: [blue, vistaBlue], startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
