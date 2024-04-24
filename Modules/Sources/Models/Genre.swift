//
//  Genre.swift
//
//
//  Created by Golan Bar-Nov on 16/04/2024.
//

import Foundation

public struct Genre: Codable, Identifiable, Hashable {
    public let id: Int
    public let name: String
}

public typealias Genres = [Genre.ID: String]

extension Genre {
    public static func genreName(for genreId: Genre.ID, type: MediaType = .all) -> String? {
        switch type {
        case .movie:
            return movieGenres[genreId]
        case .tv:
            return tvGenres[genreId]
        case .person:
            return nil
        case .all:
            return movieGenres[genreId] ?? tvGenres[genreId]
        }
    }
    
    private static var tvGenres: [Genre.ID: String] {
        [
            10759: "Action & Adventure",
            16: "Animation",
            35: "Comedy",
            80: "Crime",
            99: "Documentary",
            18: "Drama",
            10751: "Family",
            10762: "Kids",
            9648: "Mystery",
            10763: "News",
            10764: "Reality",
            10765: "Sci-Fi & Fantasy",
            10766: "Soap",
            10767: "Talk",
            10768: "War & Politics",
            37: "Western"
        ]
    }
    
    private static var movieGenres: [Genre.ID: String] {
        [
            10751: "Family",
            10749: "Romance",
            53: "Thriller",
            10752: "War",
            27: "Horror",
            10402: "Music",
            10770: "TV Movie",
            18: "Drama",
            36: "History",
            80: "Crime",
            9648: "Mystery",
            878: "Science Fiction",
            14: "Fantasy",
            35: "Comedy",
            37: "Western",
            99: "Documentary",
            28: "Action",
            16: "Animation",
            12: "Adventure"
        ]
    }
}
