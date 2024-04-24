//
//  AppView.swift
//  MoviesDB
//
//  Created by Golan Bar-Nov on 22/04/2024.
//

import SwiftUI
import Models
import Utility
import Home
import MediaList
import Favorites
import ComposableArchitecture

struct AppView: View {
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        TabView(selection: $store.currentTab.sending(\.selectTab)) {
            TabItemView(.home) {
                HomeView(store: self.store.scope(state: \.home, action: \.home))
            }
            
            TabItemView(.movies) {
                MediaListView(store: self.store.scope(state: \.movies, action: \.movies))
            }
            
            TabItemView(.tvShows) {
                MediaListView(store: self.store.scope(state: \.tvShows, action: \.tvShows))
            }
            
            TabItemView(.favorites) {
                FavoritesView(store: self.store.scope(state: \.favorites, action: \.favorites))
            }
        }
        .onChange(of: store.state.currentTab) { _, tab in
            store.send(.selectTab(tab))
        }
    }
}


/// Custom tab item wrapper view that enables the tab view to have a custom background color
private struct TabItemView<Content: View>: View {
    let tab: AppFeature.Tab
    let content: Content
    
    init(_ tab: AppFeature.Tab, @ViewBuilder content: @escaping () -> Content) {
        self.tab = tab
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            Color.theme.background.primary
                .ignoresSafeArea()
            
            VStack {
                content
                    .frame(maxHeight: .infinity)
                    .foregroundStyle(Color.theme.label.primary)
                    .toolbarBackground(Color.theme.background.secondary, for: .navigationBar)
                    .toolbarBackground(Color.theme.background.secondary, for: .tabBar)
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 1)
                    .background(Color.theme.background.secondary)
            }
        }
        .tabItem {
            Label(tab.rawValue.capitalized, systemImage: tab.systemImage)
        }
        .tag(tab)
    }
}

extension AppFeature.Tab {
    var systemImage: String {
        switch self {
        case .home:
            return "house.fill"
        case .movies:
            return "popcorn.fill"
        case .tvShows:
            return "tv.fill"
        case .favorites:
            return "heart.fill"
        }
    }
}
