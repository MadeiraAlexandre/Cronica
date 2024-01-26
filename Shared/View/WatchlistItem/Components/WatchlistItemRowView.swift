//
//  WatchlistItemRowView.swift
//  Cronica
//
//  Created by Alexandre Madeira on 07/02/22.
//

import SwiftUI
import NukeUI

struct WatchlistItemRowView: View {
    let content: WatchlistItem
    @State private var isWatched: Bool = false
    @State private var isFavorite: Bool = false
    @State private var isPin = false
    @State private var isArchive = false
    @StateObject private var settings = SettingsStore.shared
    @State private var showNote = false
    @State private var showCustomListView = false
    @Binding var showPopup: Bool
    @Binding var popupType: ActionPopupItems?
    var body: some View {
        NavigationLink(value: content) {
            HStack {
                ZStack {
                    LazyImage(url: content.backCompatibleSmallCardImage) { state in
                        if let image = state.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } else {
                            ZStack {
                                Rectangle().fill(.gray.gradient)
                                Image(systemName: "popcorn.fill")
                                    .font(.title3)
                                    .fontWidth(.expanded)
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding()
                            }
                            .frame(width: DrawingConstants.imageWidth,
                                   height: DrawingConstants.imageHeight)
                        }
                    }
                    .transition(.opacity)
                    .frame(width: DrawingConstants.imageWidth,
                           height: DrawingConstants.imageHeight)
                    if isWatched || content.watched {
                        Color.black.opacity(0.5)
                        Image(systemName: "rectangle.fill.badge.checkmark").foregroundColor(.white)
                    }
                }
                .frame(width: DrawingConstants.imageWidth,
                       height: DrawingConstants.imageHeight)
                .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.imageRadius))
                .applyHoverEffect()
                VStack(alignment: .leading) {
                    HStack {
                        Text(content.itemTitle)
                            .lineLimit(DrawingConstants.textLimit)
                            .fontDesign(.rounded)
                    }
                    HStack {
#if os(watchOS)
                        Text("\(content.itemMedia.title)")
                            .fontDesign(.rounded)
                            .font(.caption)
                            .foregroundColor(.secondary)
#else
                        if content.itemReleaseDateQuickInfo.isEmpty {
                            Text("\(content.itemMedia.title)")
                                .fontDesign(.rounded)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else {
                            if settings.showDateOnWatchlist {
                                Text("\(content.itemMedia.title) • \(content.itemReleaseDateQuickInfo)")
                                    .lineLimit(1)
                                    .fontDesign(.rounded)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else {
                                Text("\(content.itemMedia.title)")
                                    .fontDesign(.rounded)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
#endif
                        Spacer()
                    }
                }
                .padding(.leading, 2)
#if !os(watchOS)
                Spacer()
                IconGridView(isFavorite: $isFavorite, isPin: $isPin)
                    .accessibilityHidden(true)
#endif
            }
            .task {
                isWatched = content.isWatched
                isFavorite = content.isFavorite
                isPin = content.isPin
                isArchive = content.isArchive
            }
#if os(iOS) || os(macOS)
            .sheet(isPresented: $showNote) {
                NavigationStack {
                    ReviewView(id: content.itemContentID, showView: $showNote)
                }
                .presentationDetents([.large])
#if os(macOS)
                .frame(width: 400, height: 400, alignment: .center)
#elseif os(iOS)
                .appTheme()
                .appTint()
#endif
            }
#endif
            .accessibilityElement(children: .combine)
#if !os(watchOS)
            .watchlistContextMenu(item: content,
                                  isWatched: $isWatched,
                                  isFavorite: $isFavorite,
                                  isPin: $isPin,
                                  isArchive: $isArchive,
                                  showNote: $showNote,
                                  showCustomList: $showCustomListView,
                                  popupType: $popupType,
                                  showPopup: $showPopup)
            .sheet(isPresented: $showCustomListView) {
                NavigationStack {
                    ItemContentCustomListSelector(contentID: content.itemContentID,
                                                  showView: $showCustomListView,
                                                  title: content.itemTitle,
                                                  image: content.backCompatibleCardImage)
                }
                .presentationDetents([.large])
#if os(macOS)
                .frame(width: 500, height: 600, alignment: .center)
#else
                .appTheme()
                .appTint()
#endif
            }
#endif
        }
    }
}

#Preview {
    WatchlistItemRowView(content: .example, showPopup: .constant(false), popupType: .constant(nil))
}

private struct DrawingConstants {
#if os(watchOS)
    static let imageWidth: CGFloat = 70
    static let textLimit: Int = 2
#else
    static let imageWidth: CGFloat = 80
    static let textLimit: Int = 1
#endif
    static let imageHeight: CGFloat = 50
    static let imageRadius: CGFloat = 8
}
