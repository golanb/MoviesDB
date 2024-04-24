//
//  MoviesDBApp.swift
//  MoviesDB
//
//  Created by Golan Bar-Nov on 21/04/2024.
//

import SwiftUI
import Utility
import ComposableArchitecture

@main
struct MoviesDBApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(store: Store(initialState: AppFeature.State(), reducer: {
                AppFeature()._printChanges()
            }))
            .onAppear {
                applyAppearance()
            }
        }
    }
    
    
    private func applyAppearance() {
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: "arrow.backward")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.backward")
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.theme.action.inactive)
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.label.secondary)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.label.secondary)]
    }
}
