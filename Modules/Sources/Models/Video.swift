//
//  Video.swift
//
//
//  Created by Golan Bar-Nov on 10/04/2024.
//

import Foundation

public struct Video: Decodable, Identifiable, Hashable {
    public let id: String
    public let name: String
    public let key: String
    public let site: String
    public let type: String
    public let size: Int
    public let official: Bool
}

public extension Video {
    var isTrailer: Bool {
        site == "YouTube" && type == "Trailer" && official
    }
}
