//
//  Person.swift
//
//
//  Created by Golan Bar-Nov on 10/04/2024.
//

import SwiftUI
import Utility

public protocol Person: Decodable, Identifiable, Hashable {
    var name: String { get }
    var profilePath: String? { get }
}

public extension Person {
    func profileImageURL(with size: ImageSize = .regular) -> URL? {
        guard let profilePath else { return nil }
        return BaseURL.images.appending(path: size.rawValue).appending(path: profilePath)
    }
}

public struct Actor: Person {
    public let id: Int
    public let name: String
    public let character: String
    public let profilePath: String?
}

public struct Crew: Person {
    public let id: Int
    public let name: String
    public let job: String
    public let profilePath: String?
}
