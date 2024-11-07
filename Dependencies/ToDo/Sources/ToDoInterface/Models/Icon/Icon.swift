//
//  File.swift
//  ToDo
//
//  Created by Kamil Wójcicki on 04/11/2024.
//

import Design
import Foundation
import LocalDatabaseInterface
import SwiftUI

public struct Icon: LocalStorable {
    public let id: String
    public let symbol: Data?
    public let circleColor: Color

    public init(id: String = UUID().uuidString, symbol: Data?, circleColor: Color) {
        self.id = id
        self.symbol = symbol
        self.circleColor = circleColor
    }
    
    public init(from dao: IconDAO) {
        self.id = dao.id
        self.symbol = dao.symbol
        self.circleColor = Color(hex: dao.circleColor) ?? .accentColor
    }
    
    public enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case circleColor
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
