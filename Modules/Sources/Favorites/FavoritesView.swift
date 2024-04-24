//
//  FavoritesView.swift
//
//
//  Created by Golan Bar-Nov on 22/04/2024.
//

import SwiftUI
import Models
import Utility
import MediaDetails
import Shared
import ComposableArchitecture

public struct FavoritesView: View {
    @Bindable var store: StoreOf<FavoritesFeature>
    
    public init(store: StoreOf<FavoritesFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ScrollView {
                Section {
                    LazyVStack(alignment: .leading) {
                        ForEach(store.state.movies) { movie in
                            NavigationLink(state: MediaDetailsFeature.State(media: movie)) {
                                MediaRow(media: movie)
                            }
                        }
                    }
                } header: {
                    Text("Movies")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Section {
                    LazyVStack(alignment: .leading) {
                        ForEach(store.state.tvShows) { tvShow in
                            NavigationLink(state: MediaDetailsFeature.State(media: tvShow)) {
                                MediaRow(media: tvShow)
                            }
                        }
                    }
                } header: {
                    Text("TV shows")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Favorites")
            .background(Color.theme.background.primary)
        } destination: { store in
            MediaDetailsView(store: store)
        }
        .refreshable {
            store.send(.load)
        }
        .task {
            store.send(.load)
        }
    }
}


struct MediaRow: View {
    var media: Media
    
    var body: some View {
        HStack {
            MediaImageView(media: media, height: 100, contentMode: .fit)
            Text(media.title)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.theme.background.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
