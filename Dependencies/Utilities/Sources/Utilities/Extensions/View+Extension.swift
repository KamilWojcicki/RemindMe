//
//  View+Extension.swift
//
//
//  Created by Kamil Wójcicki on 23/06/2024.
//

import SwiftUI

extension View {
    
    @ViewBuilder
    public func hSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    public func vSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    public func isSameDate(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}
