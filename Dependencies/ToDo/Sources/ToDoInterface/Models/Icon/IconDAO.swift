//
//  File.swift
//  ToDo
//
//  Created by Kamil Wójcicki on 04/11/2024.
//

import Foundation
import LocalDatabaseInterface
import RealmSwift
import SwiftUI

public final class IconDAO: RealmSwift.Object, LocalDAOInterface {
    @Persisted(primaryKey: true) public var id: String
    @Persisted public var symbol: Data?
    @Persisted public var circleColor: String
    
    override public init() {
        super.init()
        self.symbol = Data()
        self.circleColor = ""
    }
    
    public init(from icon: Icon) {
        super.init()
        self.id = icon.id
        self.symbol = icon.symbol
        self.circleColor = icon.circleColor.toHex() ?? ""
    }
}
