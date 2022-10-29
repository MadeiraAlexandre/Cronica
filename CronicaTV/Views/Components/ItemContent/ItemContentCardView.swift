//
//  ItemContentCardView.swift
//  CronicaTV
//
//  Created by Alexandre Madeira on 28/10/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ItemContentCardView: View {
    let item: ItemContent
    private let context = PersistenceController.shared
    @State private var isInWatchlist: Bool = false
    @State private var isWatched = false
    @State private var showConfirmation = false
    var body: some View {
        NavigationLink(value: item) {
            WebImage(url: item.cardImageLarge)
                .resizable()
                .placeholder {
                    VStack {
                        if item.itemContentMedia == .movie {
                            Image(systemName: "film")
                        } else {
                            Image(systemName: "tv")
                        }
                        Text(item.itemTitle)
                            .lineLimit(1)
                            .foregroundColor(.secondary)
                            .padding()
                    }
                    .frame(width: DrawingConstants.imageWidth,
                           height: DrawingConstants.imageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.imageRadius, style: .continuous))
                }
                .overlay {
                    if isInWatchlist {
                        VStack {
                            Spacer()
                            HStack {
                                Text(item.itemTitle)
                                    .font(.caption)
                                    .lineLimit(1)
                                    .padding()
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
                    } else {
                        VStack {
                            Spacer()
                            HStack {
                                Text(item.itemTitle)
                                    .font(.caption)
                                    .lineLimit(1)
                                    .padding()
                                Spacer()
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
                .frame(width: DrawingConstants.imageWidth,
                       height: DrawingConstants.imageHeight)
                .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.imageRadius, style: .continuous))
                .aspectRatio(contentMode: .fill)
            .modifier(
                ItemContentContextMenu(item: item,
                                       showConfirmation: $showConfirmation,
                                       isInWatchlist: $isInWatchlist,
                                       isWatched: $isWatched)
            )
        }
        .buttonStyle(.card)
        .task {
            withAnimation {
                isInWatchlist = context.isItemSaved(id: item.id, type: item.itemContentMedia)
                if isInWatchlist && !isWatched {
                    isWatched = context.isMarkedAsWatched(id: item.id, type: item.itemContentMedia)
                }
            }
        }
    }
}


struct ItemContentCardView_Previews: PreviewProvider {
    static var previews: some View {
        ItemContentCardView(item: ItemContent.previewContent)
    }
}

private struct DrawingConstants {
    static let imageWidth: CGFloat = 360
    static let imageHeight: CGFloat = 200
    static let imageRadius: CGFloat = 12
    static let titleLineLimit: Int = 1
}