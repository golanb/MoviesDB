//
//  Review.swift
//
//
//  Created by Golan Bar-Nov on 10/04/2024.
//

import Foundation

public struct Review: Decodable, Identifiable, Hashable {
    public let id: String
    public let author: String
    public let content: String
}
