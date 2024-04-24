//
//  Media.swift
//  Networking
//
//  Created by Golan Bar-Nov on 09/04/2024.
//

import SwiftUI
import Utility

/// Represents a unified model for either a movie or a tv show
public struct Media: Decodable, Identifiable, Hashable, Equatable {
    public let id: Int
    public let mediaType: MediaType
    public let title: String
    public let posterPath: String
    public let backdropPath: String
    public let voteAverage: Double
    public let overview: String
    public var favorite: Bool
    public let genreIds: [Genre.ID]
    public let releaseDate: Date?
    public let credits: Credits
    public let videos: [Video]
    public let reviews: [Review]
    
    private enum CodingKeys: String, CodingKey {
        // shared keys
        case id, posterPath, backdropPath, voteAverage, overview, accountStates, genreIds, mediaType
        // movie only keys
        case title, genres, releaseDate
        // tv show only keys
        case name, firstAirDate
        // media details keys
        case credits, videos, reviews
        // person only keys
        case profilePath, popularity
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let mediaType = try container.decodeIfPresent(MediaType.self, forKey: .mediaType) {
            self.mediaType = mediaType
        } else {
            guard let mediaType = decoder.userInfo[.mediaType] as? MediaType else {
                throw Media.DecodingError.mediaTypeNotFound
            }
            self.mediaType = mediaType
        }
        if let genreIds = try container.decodeIfPresent([Genre.ID].self, forKey: .genreIds) {
            self.genreIds = genreIds
        } else {
            genreIds = try container.decodeIfPresent([Genre].self, forKey: .genres)?.map { $0.id } ?? []
        }
        if mediaType == .movie {
            title = try container.decode(String.self, forKey: .title)
            posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
            overview = try container.decode(String.self, forKey: .overview)
            voteAverage = try container.decode(Double.self, forKey: .voteAverage)
            if let dateString = try container.decodeIfPresent(String.self, forKey: .releaseDate), !dateString.isEmpty {
                releaseDate = try container.decodeIfPresent(Date.self, forKey: .releaseDate)
            } else {
                releaseDate = nil
            }
        } else if mediaType == .tv { // tva
            title = try container.decode(String.self, forKey: .name)
            posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? ""
            overview = try container.decode(String.self, forKey: .overview)
            voteAverage = try container.decode(Double.self, forKey: .voteAverage)
            if let dateString = try container.decodeIfPresent(String.self, forKey: .firstAirDate), !dateString.isEmpty {
                releaseDate = try container.decodeIfPresent(Date.self, forKey: .firstAirDate)
            } else {
                releaseDate = nil
            }
        } else if mediaType == .person {
            title = try container.decode(String.self, forKey: .name)
            posterPath = try container.decodeIfPresent(String.self, forKey: .profilePath) ?? ""
            overview = ""
            voteAverage = try container.decode(Double.self, forKey: .popularity)
            releaseDate = nil
        } else {
            throw Media.DecodingError.mediaTypeNotFound
        }
        id = try container.decode(Int.self, forKey: .id)
        favorite = try container.decodeIfPresent(Account.States.self, forKey: .accountStates)?.favorite ?? false
        credits = try container.decodeIfPresent(Credits.self, forKey: .credits) ?? Credits()
        videos = try container.decodeIfPresent(ListResponse<Video>.self, forKey: .videos)?.results ?? []
        reviews = try container.decodeIfPresent(ListResult<Review>.self, forKey: .reviews)?.results ?? []
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) ?? ""
    }
    
    public func posterImageURL(with size: ImageSize = .regular) -> URL {
        BaseURL.images.appending(path: size.rawValue).appending(path: posterPath)
    }
    
    public func backdropImageURL() -> URL {
        BaseURL.images.appending(path: ImageSize.backdrop.rawValue).appending(path: backdropPath)
    }
}

public enum MediaType: String, Codable {
    case movie, tv, person, all
}

public extension Media {
    enum DecodingError: Error {
        case mediaTypeNotFound
        case tvGenresNotFound
    }
}


public extension JSONDecoder {
    static func decoder(forType type: MediaType, genres: Genres = [:]) -> JSONDecoder {
        let decoder = JSONDecoder.defaultDecoder
        decoder.userInfo[.mediaType] = type
        decoder.userInfo[.genres] = genres
        return decoder
    }
}

public extension CodingUserInfoKey {
    static let mediaType = CodingUserInfoKey(rawValue: "mediaType")!
    static let genres = CodingUserInfoKey(rawValue: "genres")!
}




