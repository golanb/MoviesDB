//
//  MediaListFeature.swift
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
public struct MediaListFeature {
    struct Environment {
        public let network: Networking
    }
    
    @ObservableState
    public struct State: Equatable {
        public let mediaType: MediaType
        public var popular = MediaList(.popular)
        public var topRated = MediaList(.topRated)
        public var nowPlaying = MediaList(.nowPlaying)
        public var isLoading = false
        public var path = StackState<MediaDetailsFeature.State>()
        
        public init(mediaType: MediaType) {
            self.mediaType = mediaType
        }
    }
    
    public enum Action: Equatable {
        case load
        case loaded([Media], [Media], [Media])
        case path(StackActionOf<MediaDetailsFeature>)
    }
    
    //MARK: - Reducer
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .load:
                state.isLoading = true
                return .run { [
                    type = state.mediaType,
                    popularPage = state.popular.page,
                    topRatedPage = state.topRated.page,
                    nowPlayingPage = state.nowPlaying.page
                ] send in
                    async let popularList = environment.network.list(.popular, type: type, page: popularPage).results
                    async let topRatedList = environment.network.list(.topRated, type: type, page: topRatedPage).results
                    async let nowPlayingList = environment.network.list(.nowPlaying, type: type, page: nowPlayingPage).results
                    try await send(.loaded(popularList, topRatedList, nowPlayingList))
                }
            case let .loaded(popularList, topRatedList, nowPlayingList):
                state.popular.items = popularList
                state.topRated.items = topRatedList
                state.nowPlaying.items = nowPlayingList
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
