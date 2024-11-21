//
//  TabBarCurveShape.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 21/11/2024.
//

import SwiftUI

struct TabBarCurveShape: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            let cornerRadius: CGFloat = 45
            
            // Start w lewym górnym rogu
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            
            // Wklęsłe zaokrąglenie lewego górnego rogu
            path.addQuadCurve(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
                              control: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
            
            // Linia do prawego górnego rogu
            path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius))
            
            // Wklęsłe zaokrąglenie prawego górnego rogu
            path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY),
                              control: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius))
            
            // Linia w dół do prawego dolnego rogu
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            
            // Linia wzdłuż dolnej krawędzi do lewego dolnego rogu
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            
            // Zamknięcie ścieżki
            path.closeSubpath()
        }
    }
}

#Preview {
    TabBarCurveShape()
}
