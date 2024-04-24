//
//  Credits.swift
//
//
//  Created by Golan Bar-Nov on 16/04/2024.
//

import Foundation

public struct Credits: Decodable, Hashable {
    public let cast: [Actor]
    public let crew: [Crew]
    
    init(cast: [Actor] = [], crew: [Crew] = []) {
        self.cast = cast
        self.crew = crew
    }
}
