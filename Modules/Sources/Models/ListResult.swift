//
//  ListResult.swift
//
//
//  Created by Golan Bar-Nov on 21/04/2024.
//

import Foundation

public struct ListResult<Result: Decodable>: Decodable {
    public let results: [Result]
    public let totalResults: Int
    public let totalPages: Int
    public let page: Int
}

struct ListResponse<Result: Decodable>: Decodable {
    public let results: [Result]
}
