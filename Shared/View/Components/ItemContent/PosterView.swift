//
//  PosterView.swift
//  Story
//
//  Created by Alexandre Madeira on 17/01/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct PosterView: View {
    let item: ItemContent
    private let context = PersistenceController.shared
    @State private var isInWatchlist = false
    @State private var isWatched = false
    @Binding var addedItemConfirmation: Bool
    var body: some View {
        NavigationLink(value: item) {
            WebImage(url: item.posterImageMedium, options: .highPriority)
                .resizable()
                .placeholder {
                    PosterPlaceholder(title: item.itemTitle, type: item.itemContentMedia)
                }
                .overlay {
                    if isInWatchlist {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                if isWatched {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding()
                                } else {
                                    Image(systemName: "square.stack.fill")
                                        .foregroundColor(.white.opacity(0.8))
                                        .padding()
                                }
                            }
                            .background {
                                Color.black.opacity(0.5)
                                    .mask {
                                        LinearGradient(colors:
                                                        [Color.black,
                                                         Color.black.opacity(0.924),
                                                         Color.black.opacity(0.707),
                                                         Color.black.opacity(0.383),
                                                         Color.black.opacity(0)],
                                                       startPoint: .bottom,
                                                       endPoint: .top)
                                    }
                            }
                        }
                    }
                }
                .aspectRatio(contentMode: .fill)
                .transition(.opacity)
                .frame(width: DrawingConstants.posterWidth,
                       height: DrawingConstants.posterHeight)
                .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.posterRadius,
                                            style: .continuous))
                .shadow(radius: DrawingConstants.shadowRadius)
                .padding(.zero)
                .applyHoverEffect()
                .modifier(
                    ItemContentContextMenu(item: item,
                                           showConfirmation: $addedItemConfirmation,
                                           isInWatchlist: $isInWatchlist,
                                           isWatched: $isWatched)
                )
                .task {
                    withAnimation {
                        isInWatchlist = context.isItemSaved(id: item.id, type: item.itemContentMedia)
                        if isInWatchlist && !isWatched {
                            isWatched = context.isMarkedAsWatched(id: item.id, type: item.itemContentMedia)
                        }
                    }
                }
#if os(iOS) || os(macOS)
                .draggable(item)
#endif
        }
    }
}

struct PosterView_Previews: PreviewProvider {
    @State static var show = false
    static var previews: some View {
        PosterView(item: ItemContent.previewContent, addedItemConfirmation: $show)
    }
}

struct PosterPlaceholder: View {
    var title: String
    let type: MediaType
    var body: some View {
        ZStack {
            Rectangle().fill(.gray.gradient)
            VStack {
                Text(title)
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(1)
                    .padding()
                Image(systemName: type == .tvShow ? "tv" : "film")
                    .font(.title)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
        .frame(width: DrawingConstants.posterWidth,
               height: DrawingConstants.posterHeight)
        .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.posterRadius,
                                    style: .continuous))
        .shadow(radius: DrawingConstants.shadowRadius)
    }
}

private struct DrawingConstants {
    static let posterWidth: CGFloat = 160
    static let posterHeight: CGFloat = 240
    static let posterRadius: CGFloat = 8
    static let shadowRadius: CGFloat = 2
}
