//
//  CoreInterface.swift
//  
//
//  Created by Kamil Wójcicki on 07/08/2024.
//

import Foundation

@MainActor
public protocol ViewModelInterface: ObservableObject {
    associatedtype State
    associatedtype Event
    
     var state: State { get }
    func trigger(_ event: Event)
}
