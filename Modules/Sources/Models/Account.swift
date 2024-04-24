//
//  Account.swift
//
//
//  Created by Golan Bar-Nov on 17/04/2024.
//

import SwiftUI

public struct Account: Decodable, Identifiable, Hashable {
    public let id: Int
    public let username: String
    
    public init() {
        id = 0
        username = ""
    }
}

extension Account {
    struct States: Decodable {
        let favorite: Bool
        let rated: Bool
        let watchlist: Bool
    }
}
