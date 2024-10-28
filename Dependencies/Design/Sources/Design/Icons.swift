//
//  Icons.swift
//  
//
//  Created by Kamil Wójcicki on 17/08/2024.
//

import SwiftUI

public struct Icons {
    public static let dinner = fromModule("dinner")
    public static let tap = fromModule("tap")
    public static let tray = fromModule("tray")
    public static let clipboard = fromModule("clipboard")
    public static let photo = fromModule("photo")
    public static let birthday = fromModule("birthday")
    public static let cat = fromModule("cat")
    public static let cinema = fromModule("cinema")
    public static let dentist = fromModule("dentist")
    public static let dog = fromModule("dog")
    public static let football = fromModule("football")
    public static let learning = fromModule("learning")
    public static let roadTrip = fromModule("roadTrip")
    public static let running = fromModule("running")
    public static let shopping = fromModule("shopping")
    public static let vacation = fromModule("vacation")
    
    private static func fromModule(_ name: String) -> UIImage? {
        UIImage(named: name, in: .module, with: .none)
    }
}
