//
//  MediaDetailsView.swift
//
//
//  Created by Golan Bar-Nov on 21/04/2024.
//

import SwiftUI
import Models
import Utility
import Shared
import YouTubePlayerKit
import ComposableArchitecture

public struct MediaDetailsView: View {
    
    let store: StoreOf<MediaDetailsFeature>
    
    public init(store: StoreOf<MediaDetailsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ScrollView {
            // Mark: Header view
            Section {
                HStack(alignment: .bottom, spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                        if let releaseDate = store.state.media.releaseDate {
                            Label(
                                title: { Text(releaseDate, style: .date) },
                                icon: { Image(systemName: "calendar") }
                            )
                        }
                        
                        Label(
                            title: { Text("\(store.state.media.voteAverage, format: .number.precision(.fractionLength(1)))/10 (IMDB)") },
                            icon: { Image(systemName: "hand.thumbsup.fill") }
                        )
                        
                        Label(
                            title: { Text(store.state.media.genreIds.map { store.state.genreName(for: $0) }, format: .list(type: .and)) },
                            icon: { Image(systemName: "books.vertical") }
                        )
                        
                        Button(action: {
                            store.send(.toggleFavorite)
                        }, label: {
                            Label(store.state.favoriteButtonTitle, systemImage: store.state.favoriteButtonImage)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        })
                        .symbolEffect(.bounce, value: store.state.media.favorite)
                        .buttonStyle(.borderedProminent)
                        .font(.caption)
                        .foregroundStyle(Color.theme.label.primary)
                    }
                    MediaImageView(media: store.state.media, height: 240, contentMode: .fit)
                        .frame(width: 160)
                }
            } header: {
                Text(store.state.media.title)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .foregroundStyle(Color.theme.label.secondary)
            }
            
            // Mark: sinopsis
            
            DetailsSection(header: "sinopsis") {
                Text(store.media.overview)
            }
            
            // Mark: Trailer
            
            DetailsSection(header: "Trailer") {
                YouTubePlayerView(store.player) { state in
                    switch state {
                    case .idle:
                        ProgressView()
                    case .ready:
                        EmptyView()
                    case .error(let error):
                        Text(verbatim: error.localizedDescription)
                    }
                }
                .frame(height: 200)
                .background(Color.theme.background.primary)
                .cornerRadius(20)
            }
            
            // Mark: Cast
            
            if !store.media.credits.cast.isEmpty {
                DetailsSection(header: "Cast") {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 8) {
                            ForEach(store.media.credits.cast) { actor in
                                AvatarView(person: actor)
                                    .frame(width: 80, height: 150)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                }
            }
            
            // Mark: Reviews
            
            if !store.media.reviews.isEmpty {
                DetailsSection(header: "Reviews") {
                    ScrollView {
                        LazyVStack {
                            ForEach(store.media.reviews) { review in
                                ReviewView(review: review)
                            }
                        }
                    }
                }
            }
        }
        .font(.subheadline)
        .foregroundStyle(Color.theme.label.secondary)
        .ignoresSafeArea(edges: .horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("", systemImage: "arrow.backward") {
                    store.send(.dismissTapped)
                }
                .fontWeight(.bold)
            }
        }
        .background {
            ZStack {
                Color.theme.background.primary
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                VStack {
                    MediaImageView(media: store.media, height: 400, contentMode: .fill)
                    Spacer()
                }
                LinearGradient(stops: [
                    Gradient.Stop(color: .clear, location: 0),
                    Gradient.Stop(color: .theme.background.primary, location: 0.3),
                ], startPoint: .top, endPoint: .bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
        }
        .task {
            store.send(.load)
        }
    }
}

// MARK: - Helper views

private struct DetailsSection<Content: View>: View {
    let header: String
    let content: Content
    
    init(header: String, @ViewBuilder content: @escaping () -> Content) {
        self.header = header
        self.content = content()
    }
    
    var body: some View {
        Section {
            content
                .frame(maxWidth: .infinity, alignment: .leading)
        } header: {
            Text(header)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
        }
    }
}

struct AvatarView: View {
    let person: any Person
    
    var body: some View {
        if let url = person.profileImageURL() {
            VStack(spacing: 0) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                    
                } placeholder: {
                    Image(systemName: "photo")
                        .scaleEffect(4)
                        .foregroundStyle(Color.theme.background.secondary)
                }
                Text(person.name)
                    .font(.caption2)
                    .frame(height: 30)
            }
        }
    }
}

struct ReviewView : View {
    let review: Review
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(review.author, systemImage: "person.fill")
                .font(.headline)
                .fontWeight(.medium)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(review.content)
            Divider()
                .frame(maxWidth: .infinity)
                .overlay(Color.theme.label.primary)
                .padding(.vertical, 10)
        }
    }
}

