//
//  HeroImage.swift
//  Story (iOS)
//
//  Created by Alexandre Madeira on 05/04/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct HeroImage: View {
    let url: URL?
    let title: String
    var blurImage: Bool = false
    var body: some View {
        WebImage(url: url)
            .resizable()
            .placeholder {
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
            .transition(.fade)
            .aspectRatio(contentMode: .fill)
            .transition(.opacity)
    }
}

struct HeroImage_Previews: PreviewProvider {
    static var previews: some View {
        HeroImage(url: ItemContent.previewContent.cardImageLarge,
                  title: ItemContent.previewContent.itemTitle)
    }
}
