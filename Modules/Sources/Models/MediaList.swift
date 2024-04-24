//
//  File.swift
//  
//
//  Created by Golan Bar-Nov on 23/04/2024.
//

import Foundation
//import ComposableArchitecture

public typealias Page = Int

public struct MediaList: Hashable {
    public let name: Name
    public var page: Page = 1
//    public var items: IdentifiedArrayOf<Media> = []
    public var items: [Media] = []
    
    public init(_ name: Name, page: Page = 1, items: [Media] = []) {
        self.name = name
        self.page = page
        self.items = items
    }
}

public extension MediaList {
    enum Name: String, Hashable, CaseIterable {
        case popular
        case topRated = "top_rated"
        case nowPlaying = "now_playing"
    }
}
