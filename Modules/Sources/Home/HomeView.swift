//
//  HomeView.swift
//
//
//  Created by Golan Bar-Nov on 23/04/2024.
//

import SwiftUI
import Models
import Utility
import Shared
import MediaDetails
import ComposableArchitecture

public struct HomeView: View {
    @Bindable var store: StoreOf<HomeFeature>
    
    private var moviesTitle: String {
        store.state.isSearching ? "Movies" : "Popular movies"
    }
    
    private var tvShowsTitle: String {
        store.state.isSearching ? "TV shows" : "Popular TV shows"
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ScrollView {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Dune, Star Wars, ...", text: $store.searchQuery.sending(\.searchQueryChanged))
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    if store.state.isSearching {
                        Button("Cancel") {
                            store.send(.searchCanceled)
                        }
                    }
                }
                .padding(.horizontal, 16)
                if !store.state.isSearching {
                    HorizontalCardList(medias: store.state.trending, header: "Trending")
                        .redacted(reason: store.state.isSearching ? .placeholder : [])
                }
                HorizontalCardList(medias: store.state.movies, header: moviesTitle)
                HorizontalCardList(medias: store.state.tvShows, header: tvShowsTitle)
            }
            .background(Color.theme.background.primary)
            .task {
                store.send(.load)
            }
            .task(id: store.searchQuery) {
                do {
                    try await Task.sleep(for: .milliseconds(300))
                    await store.send(.searchQueryChangeDebounced).finish()
                } catch {}
            }
//            .searchable(text: $store.state.searchString, placement: .navigationBarDrawer)
//            .onChange(of: store.state.searchString) { _, newValue in
//                if newValue.isEmpty {
//                    store.state.searchDismissed()
//                }
//            }
        } destination: { store in
            MediaDetailsView(store: store)
        }
    }
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
}

private struct HorizontalCardList: View {
    let medias: [Media]
    let header: String
    
    var body: some View {
        Section {
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(medias) { media in
                        NavigationLink(state: MediaDetailsFeature.State(media: media)) {
                            MediaImageView(media: media, height: 220, contentMode: .fit)
                        }
                    }
                }
                .padding()
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled()
        } header: {
            Text(header)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
        }
    }
}
