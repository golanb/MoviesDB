//
//  AppFeature.swift
//  MoviesDB
//
//  Created by Golan Bar-Nov on 22/04/2024.
//

import Foundation
import Models
import Home
import MediaList
import Favorites
import ComposableArchitecture

@Reducer
struct AppFeature {

    enum Tab: String {
        case home, movies, tvShows = "tv shows", favorites
    }
    
    @ObservableState
    struct State: Equatable {
        var currentTab: Tab = .home
        var home = HomeFeature.State()
        var movies = MediaListFeature.State(mediaType: .movie)
        var tvShows = MediaListFeature.State(mediaType: .tv)
        var favorites = FavoritesFeature.State()
    }
    
    enum Action: Equatable {
        case selectTab(Tab)
        case home(HomeFeature.Action)
        case movies(MediaListFeature.Action)
        case tvShows(MediaListFeature.Action)
        case favorites(FavoritesFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
//        .onChange(of: \.home.popularMovies) { _, movies in
//            Reduce { state, _ in
//                state.movies.popular.items = movies
//                return .none
//            }
//        }

        Scope(state: \.movies, action: \.movies) {
            MediaListFeature()
        }
        
        Scope(state: \.tvShows, action: \.tvShows) {
            MediaListFeature()
        }
        
        Scope(state: \.favorites, action: \.favorites) {
            FavoritesFeature()
        }
        
        Reduce { state, action in
            switch action {
            case let .selectTab(tab):
                state.currentTab = tab
                return .none
            case .home:
                return .none
            case .movies:
                return .none
            case .tvShows:
                return .none
            case .favorites:
                return .none
            }
        }
    }
}
