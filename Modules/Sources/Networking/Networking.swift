//
//  ListNetworking.swift
//
//
//  Created by Golan Bar-Nov on 09/04/2024.
//

import Foundation
import Models
import Utility

public protocol Networking {
    func account() async throws -> Account
    func trending(_ type: MediaType, timeWindow: TimeWindow) async throws -> ListResult<Media>
    func list(_ list: MediaList.Name, type: MediaType, page: Page) async throws -> ListResult<Media>
    func search(_ type: MediaType, query: String, page: Page) async throws -> ListResult<Media>
    func details(_ type: MediaType, id: Media.ID) async throws -> Media
    func favoriteMovies(_ account: Account.ID) async throws -> ListResult<Media>
    func favoriteTVShows(_ account: Account.ID) async throws -> ListResult<Media>
    func toggleFavorite(_ media: Media, account: Account.ID) async throws -> Bool
    func genres(_ type: MediaType) async throws -> [Genre.ID: String]
}

extension Network: Networking {
    public func account() async throws -> Account {
        try await request(path: "/account")
    }
    
    public func trending(_ type: MediaType = .all, timeWindow: TimeWindow = .day) async throws -> ListResult<Media> {
        let path = "/trending/\(type.rawValue)/\(timeWindow.rawValue)"
        let decoder: JSONDecoder = .decoder(forType: type)
        return try await request(path: path, decoder: decoder)
    }
    
    public func favoriteMovies(_ account: Account.ID) async throws -> ListResult<Media> {
        try await request(path: "/account/\(account)/favorite/movies", decoder: .decoder(forType: .movie))
    }
    
    public func favoriteTVShows(_ account: Account.ID) async throws -> ListResult<Media> {
        try await request(path: "/account/\(account)/favorite/tv", decoder: .decoder(forType: .tv))
    }
    
    public func toggleFavorite(_ media: Media, account: Account.ID) async throws -> Bool {
        let body: [String: Any] = [
            "media_type": media.mediaType.rawValue,
            "media_id": media.id,
            "favorite": !media.favorite
        ]
        let response: Response = try await request(path: "/account/\(account)/favorite", method: .post, body: body)
        return response.success
    }
    
    public func genres(_ type: MediaType) async throws -> [Genre.ID: String] {
        let response: GenreList = try await request(path: "/genre/\(type.rawValue)/list")
        var result = [Genre.ID: String]()
        for genre in response.genres {
            result[genre.id] = genre.name
        }
        return result
    }
    
    public func list(_ list: MediaList.Name, type: MediaType, page: Page) async throws -> ListResult<Media> {
        let path = list == .nowPlaying && type == .tv ? "/tv/airing_today" : "/\(type.rawValue)/\(list.rawValue)"
        let decoder: JSONDecoder = .decoder(forType: type)
        return try await request(path: path, urlParameters: ["page": page], decoder: decoder)
    }
    
    public func search(_ type: MediaType = .all, query: String, page: Page = 1) async throws -> ListResult<Media> {
        let path = "/search/\(type.searchPath)"
        return try await request(path: path, urlParameters: ["query": query, "page": page], decoder: .decoder(forType: type))
    }
    
    public func details(_ type: MediaType, id: Media.ID) async throws -> Media {
        let path = "/\(type.rawValue)/\(id)"
        let parameters = ["append_to_response": "account_states,credits,videos,reviews"]
        return try await request(path: path, urlParameters: parameters, decoder: .decoder(forType: type))
    }
}

fileprivate extension MediaType {
    var searchPath: String {
        self == .all ? "multi" : rawValue
    }
}

struct GenreList: Decodable {
    let genres: [Genre]
}

struct Response: Decodable {
    let success: Bool
    let statusCode: Int
    let statusMessage: String
}

public enum TimeWindow: String {
    case day, week
}
