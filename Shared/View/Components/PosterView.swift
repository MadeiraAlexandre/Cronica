//
//  PosterView.swift
//  Story
//
//  Created by Alexandre Madeira on 17/01/22.
//

import SwiftUI

struct PosterView: View {
    let title: String
    let url: URL?
    var body: some View {
        AsyncImage(url: url,
                   transaction: Transaction(animation: .easeInOut)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .transition(.opacity)
            } else if phase.error != nil {
                Rectangle().redacted(reason: .placeholder)
            } else {
                ZStack {
                    Rectangle().fill(.thickMaterial)
                    VStack {
                        Text(title)
                            .lineLimit(1)
                            .padding(.bottom)
                        Image(systemName: "film")
                    }
                    .padding()
                    .foregroundColor(.secondary)
                }
            }
        }
        .frame(width: DrawingConstants.posterWidth,
               height: DrawingConstants.posterHeight)
        .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.posterRadius,
                                    style: .continuous))
        .shadow(color: .black.opacity(DrawingConstants.shadowOpacity),
                radius: DrawingConstants.shadowRadius)
    }
}

struct PosterView_Previews: PreviewProvider {
    static var previews: some View {
        PosterView(title: Content.previewContent.itemTitle,
                   url: Content.previewContent.posterImageMedium)
    }
}

private struct DrawingConstants {
    static let posterWidth: CGFloat = 160
    static let posterHeight: CGFloat = 240
    static let posterRadius: CGFloat = 8
    static let shadowOpacity: Double = 0.5
    static let shadowRadius: CGFloat = 2.5
}
