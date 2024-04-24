//
//  MediaListView.swift
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

public struct MediaListView: View {
    @Bindable var store: StoreOf<MediaListFeature>
    @State private var selectedTab: MediaList.Name?
    @State private var tabProgress: CGFloat = 0
    
    public init(store: StoreOf<MediaListFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            VStack {
                MediaListSegmentedControlView(selectedTab: $selectedTab, tabProgress: tabProgress)
                GeometryReader { proxy in
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 0) {
                            mediaGridView(store.state.topRated)
                            mediaGridView(store.state.nowPlaying)
                            mediaGridView(store.state.popular)
                        }
                        .scrollTargetLayout()
                        .offsetX { value in
                            /// Converting Offset into Progress
                            let progress = -value / (proxy.size.width * CGFloat(MediaList.Name.allCases.count - 1))
                            /// Capping Progress BTW 0-1
                            tabProgress = max(min(progress, 1), 0)
                        }
                    }
                    .scrollPosition(id: $selectedTab)
                    .scrollIndicators(.hidden)
                    .scrollTargetBehavior(.paging)
                    .scrollClipDisabled()
                    .refreshable {
                        store.send(.load)
                    }
                }
            }
            .navigationTitle(store.state.mediaType.title)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.theme.background.primary)
        } destination: { store in
            MediaDetailsView(store: store)
        }
        .task {
            store.send(.load)
        }
    }
    

    
    @ViewBuilder
    func mediaGridView(_ list: MediaList) -> some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        ScrollView(.vertical) {
            LazyVGrid(columns: columns) {
                ForEach(list.items) { media in
                    NavigationLink(state: MediaDetailsFeature.State(media: media)) {
                        MediaImageView(media: media, height: 150, contentMode: .fit)
                    }
                }
            }
        }
        .id(list.name)
        .scrollIndicators(.hidden)
        .containerRelativeFrame(.horizontal)
    }
}


struct MediaListSegmentedControlView: View {
    @Binding var selectedTab: MediaList.Name?
    let tabProgress: CGFloat
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(MediaList.Name.allCases, id: \.rawValue) { tab in
                Text(tab.title)
                    .font(.callout)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .contentShape(.capsule)
                    .onTapGesture {
                        /// Updating Tab
                        withAnimation(.snappy) {
                            selectedTab = tab
                        }
                    }
            }
        }
        .tabMask(tabProgress)
        .background { // Active tab indicator
            GeometryReader {
                let size = $0.size
                let capsuleWidth = size.width / CGFloat(MediaList.Name.allCases.count)
                
                Capsule()
                    .fill(Color.theme.action.primary)
                    .frame(width: capsuleWidth)
                    .offset(x: tabProgress * (size.width - capsuleWidth))
            }
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal, 15)
    }
}


/// Offset Key
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                    Color.clear
                        .preference(key: OffsetKey.self, value: minX)
                        .onPreferenceChange(OffsetKey.self, perform: completion)
                }
            }
    }
    
    /// Tab bar Masking
    @ViewBuilder
    func tabMask(_ tabProgress: CGFloat) -> some View {
        ZStack {
            self
                .foregroundStyle(.gray)
            self
                .symbolVariant(.fill)
                .mask {
                    GeometryReader {
                        let size = $0.size
                        let capsuleWidth = size.width / CGFloat(MediaList.Name.allCases.count)
                        Capsule()
                            .frame(width: capsuleWidth)
                            .offset(x: tabProgress * (size.width - capsuleWidth))
                    }
                }
        }
    }
}


extension MediaList.Name {
    var title: String {
        switch self {
        case .topRated:
            return "Top Rated"
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        }
    }
}

extension MediaType {
    var title: String {
        switch self {
        case .movie:
            return "Movies"
        case .tv:
            return "TV Shows"
        default:
            return ""
        }
    }
}
