//
//  TabBarView.swift
//
//
//  Created by Kamil Wójcicki on 08/04/2024.
//

import SwiftUI

//MARK: Create TabBarView
public struct TabBarView: View {
    @StateObject private var viewModel = TabBarViewModel()
    
    public init() { }
    
    public var body: some View {
        Text("Tab Bar View")
    }
}

#Preview {
    TabBarView()
}
