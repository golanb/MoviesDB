//
//  MediaImageView.swift
//
//
//  Created by Golan Bar-Nov on 21/04/2024.
//

import SwiftUI
import Models
import Utility

public struct MediaImageView: View {
    public let media: Media
    public let height: CGFloat
    public let contentMode: ContentMode
    
    public init(media: Media, height: CGFloat = 220, contentMode: ContentMode = .fit) {
        self.media = media
        self.height = height
        self.contentMode = contentMode
    }
    
    public var body: some View {
        AsyncImage(url: media.posterImageURL()) { image in
            image
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } placeholder: {
            Image(systemName: "photo")
                .scaleEffect(4)
                .foregroundStyle(Color.theme.background.secondary)
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

