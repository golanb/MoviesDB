//
//  MediaDetailsFeature.swift
//
//
//  Created by Golan Bar-Nov on 21/04/2024.
//

import Foundation
import Models
import Networking
import YouTubePlayerKit
import ComposableArchitecture

struct DetailsEnvironment {
    let network: Networking
}

@Reducer
public struct MediaDetailsFeature {
    private let environment = DetailsEnvironment(network: Network.shared)
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        public var media: Media
        public var account = Account()
        public var player = YouTubePlayer(configuration: .init(autoPlay: false))
        public var genres: Genres = [:]
        
        public init(media: Media) {
            self.media = media
        }
        
        public var favoriteButtonTitle: String {
            media.favorite ? "Remove from Favorites" : "Add to Favorites"
        }
        
        public var favoriteButtonImage: String {
            media.favorite ? "heart.slash.fill" : "heart.fill"
        }
        
        func genreName(for id: Genre.ID) -> String {
            guard let name = genres[id] ?? Genre.genreName(for: id, type: media.mediaType) else {
                debugPrint("Genre name not found for id:\(id)!")
                return ""
            }
            return name
        }
    }
    
    public enum Action: Equatable {
        case load
        case loaded(Media, Account, Genres)
        case toggleFavorite
        case favoriteToggled
        case dismissTapped
        case delegate(Delegate)
        
        public enum Delegate: Equatable {
            case favoriteToggled
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    //MARK: - Reducer
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .load:
                return .run { [type = state.media.mediaType, id = state.media.id] send in
                    let genres = try await environment.network.genres(type)
                    let media = try await environment.network.details(type, id: id)
                    let account = try await environment.network.account()
                    await send(.loaded(media, account, genres))
                }
            case let .loaded(media, account, genres):
                state.media = media
                state.account = account
                state.genres = genres
                if let id = media.videos.first(where: { $0.isTrailer })?.key {
                    state.player.source = .video(id: id)
                }
                return .none
            case .toggleFavorite:
                return .run { [media = state.media, account = state.account.id] send in
                    let _ = try await environment.network.toggleFavorite(media, account: account)
                    await send(.favoriteToggled)
                }
            case .favoriteToggled:
                state.media.favorite.toggle()
                return .send(.delegate(.favoriteToggled))
            case .dismissTapped:
                return .run { _ in await self.dismiss() }
            case .delegate:
                return .none
            }
        }
    }
}
