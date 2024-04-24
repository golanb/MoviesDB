//
//  HomeFeature.swift
//
//
//  Created by Golan Bar-Nov on 23/04/2024.
//

import Foundation
import Models
import Networking
import MediaDetails
import ComposableArchitecture

@Reducer
public struct HomeFeature {
    struct Environment {
        public let network: Networking
    }
    
    @ObservableState
    public struct State: Equatable {
        var popularMovies = [Media]()
        var popularTVShows = [Media]()
        public var trending = [Media]()
        public var movies = [Media]()
        public var tvShows = [Media]()
        public var searchQuery = ""
        public var isLoading = false
        public var path = StackState<MediaDetailsFeature.State>()
        
        var isSearching: Bool {
            !searchQuery.isEmpty
        }
        
        public init() {}
    }
    
    public enum Action: Equatable {
        case load
        case loaded([Media], [Media], [Media])
        case searchQueryChanged(String)
        case searchQueryChangeDebounced
        case searchResults(SearchResults)
        case searchCanceled
        case path(StackActionOf<MediaDetailsFeature>)
    }
    
    private enum CancelID { case title }
    
    public struct SearchResults: Equatable {
        let movies: [Media]
        let tvShows: [Media]
    }
    
    //MARK: - Reducer
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .load:
                state.isLoading = true
                return .run { send in
                    async let trending = environment.network.trending(.all, timeWindow: .day).results
                    async let popularMovies = environment.network.list(.popular, type: .movie, page: 1).results
                    async let popularTVShows = environment.network.list(.popular, type: .tv, page: 1).results
                    try await send(.loaded(trending, popularMovies, popularTVShows))
                }
            case let .loaded(trending, popularMovies, popularTVShows):
                state.trending = trending
                state.popularMovies = popularMovies
                state.popularTVShows = popularTVShows
                state.movies = state.popularMovies
                state.tvShows = state.popularTVShows
                state.isLoading = false
                return .none
            case let .searchResults(results):
                state.movies = results.movies
                state.tvShows = results.tvShows
                return .none
            case let .searchQueryChanged(query):
                state.searchQuery = query
                return .none
            case .searchQueryChangeDebounced:
                guard !state.searchQuery.isEmpty else {
                    state.movies = state.popularMovies
                    state.tvShows = state.popularTVShows
                    return .none
                }
                return .run { [query = state.searchQuery] send in
                    do {
                        async let movies = environment.network.search(.movie, query: query, page: 1).results
                        async let tvShows = environment.network.search(.tv, query: query, page: 1).results
                        let results = try await SearchResults(movies: movies, tvShows: tvShows)
                        await send(.searchResults(results))
                    } catch {
                        debugPrint(error)
                        return
                    }
                }
                .cancellable(id: CancelID.title)
            case .searchCanceled:
                state.searchQuery = ""
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            MediaDetailsFeature()
        }
    }
    
    private let environment = Environment(network: Network.shared)
    
    public init() {
    }
}
