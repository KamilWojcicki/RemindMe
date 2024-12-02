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
    
    private static func fromModule(_ name: String) -> UIImage? { UIImage(named: name, in: .module, with: .none) }
}

public struct Icon: Hashable {
    public let symbol: Data?
    public let circleColor: Color
    
    public init(symbol: Data?, circleColor: Color) {
        self.symbol = symbol
        self.circleColor = circleColor
    }
    
    public static let tapIcon       = Icon(symbol: Icons.tap?.pngData() ?? Data(), circleColor: .blue.opacity(0.2))
    public static let dishIcon      = Icon(symbol: Icons.dinner?.pngData() ?? Data(), circleColor: .brown)
    public static let trayIcon      = Icon(symbol: Icons.tray?.pngData() ?? Data(), circleColor: .blue.opacity(0.2))
    public static let clipboardIcon = Icon(symbol: Icons.clipboard?.pngData() ?? Data(), circleColor: .yellow)
    public static let photoIcon     = Icon(symbol: Icons.photo?.pngData() ?? Data(), circleColor: .blue.opacity(0.1))
    public static let birthdayIcon  = Icon(symbol: Icons.birthday?.pngData() ?? Data(), circleColor: .yellow.opacity(0.5))
    public static let catIcon       = Icon(symbol: Icons.cat?.pngData() ?? Data(), circleColor: .green.opacity(0.6))
    public static let cinemaIcon    = Icon(symbol: Icons.cinema?.pngData() ?? Data(), circleColor: .red.opacity(0.5))
    public static let dentist       = Icon(symbol: Icons.dentist?.pngData() ?? Data(), circleColor: .green.opacity(0.7))
    public static let dog           = Icon(symbol: Icons.dog?.pngData() ?? Data(), circleColor: .yellow.opacity(0.7))
    public static let football      = Icon(symbol: Icons.football?.pngData() ?? Data(), circleColor: .purple.opacity(0.4))
    public static let learning      = Icon(symbol: Icons.learning?.pngData() ?? Data(), circleColor: .blue.opacity(0.4))
    public static let roadTrip      = Icon(symbol: Icons.roadTrip?.pngData() ?? Data(), circleColor: .red.opacity(0.3))
    public static let running       = Icon(symbol: Icons.running?.pngData() ?? Data(), circleColor: .red.opacity(0.4))
    public static let shopping      = Icon(symbol: Icons.shopping?.pngData() ?? Data(), circleColor: .yellow.opacity(0.5))
    public static let vacation      = Icon(symbol: Icons.vacation?.pngData() ?? Data(), circleColor: .orange.opacity(0.6))
    
    public static let iconToString: [Icon: String] = [
        tapIcon: "tapIcon",
        dishIcon: "dishIcon",
        trayIcon: "trayIcon",
        clipboardIcon: "clipboardIcon",
        photoIcon: "photoIcon",
        birthdayIcon: "birthdayIcon",
        catIcon: "catIcon",
        cinemaIcon: "cinemaIcon",
        dentist: "dentist",
        dog: "dog",
        football: "football",
        learning: "learning",
        roadTrip: "roadTrip",
        running: "running",
        shopping: "shopping",
        vacation: "vacation"
    ]
    
    public static func name(for icon: Icon) -> String { iconToString[icon] ?? "" }
    
    public static func icon(for name: String) -> Icon { iconToString.first(where: { $0.value == name })?.key ?? .clipboardIcon }
    
    public static let allIcons: [Icon] = [
        dishIcon,
        clipboardIcon,
        birthdayIcon,
        catIcon,
        cinemaIcon,
        dentist,
        dog,
        football,
        learning,
        roadTrip,
        running,
        shopping,
        vacation
    ]
}
