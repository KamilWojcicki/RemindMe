//
//  RootViewModel.swift
//  RemindMe
//
//  Created by Kamil Wójcicki on 13/06/2024.
//

import Foundation
import SwiftUI

final class RootViewModel: ObservableObject {
    @AppStorage("isFirstAppear") var isFirstAppear: Bool = true
}
