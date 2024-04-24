//
//  FavoritesFeature.swift
//
//
//  Created by Golan Bar-Nov on 21/04/2024.
//

import Foundation
import Models
import Networking
import MediaDetails
import ComposableArchitecture

@Reducer
public struct FavoritesFeature {
    struct Environment {
        public let network: Networking
    }
    
    @ObservableState
    public struct State: Equatable {
        public var movies: IdentifiedArrayOf<Media> = []
        public var tvShows: IdentifiedArrayOf<Media> = []
        public var account = Account()
        public var isLoading = false
        public var path = StackState<MediaDetailsFeature.State>()
        
        public init() {
        }
    }
    
    public enum Action: Equatable {
        case load
        case loaded(Account, [Media], [Media])
        case path(StackActionOf<MediaDetailsFeature>)
    }
    
    //MARK: - Reducer
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .load:
                state.isLoading = true
                return .run { send in
                    let account = try await environment.network.account()
                    async let movies = environment.network.favoriteMovies(account.id).results
                    async let tvShows = environment.network.favoriteTVShows(account.id).results
                    try await send(.loaded(account, movies, tvShows))
                }
            case let .loaded(account, movies, tvShows):
                state.account = account
                state.movies = IdentifiedArrayOf<Media>(uniqueElements: movies)
                state.tvShows = IdentifiedArrayOf<Media>(uniqueElements: tvShows)
                state.isLoading = false
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
