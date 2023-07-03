//
//  HorizontalItemContentListView.swift
//  Story (iOS)
//
//  Created by Alexandre Madeira on 06/06/22.
//

import SwiftUI

/// Display a list of ItemContent within PosterView, with a TitleView indicating
/// its origin.
struct HorizontalItemContentListView: View {
    let items: [ItemContent]?
    let title: String
    let subtitle: String
    @Binding var addedItemConfirmation: Bool
    var displayAsCard = false
    var endpoint: Endpoints?
    @StateObject private var settings = SettingsStore.shared
    var body: some View {
        if let items {
            if !items.isEmpty {
                VStack {
#if os(tvOS)
                    TitleView(title: title, subtitle: subtitle)
                        .padding(.leading, 32)
#else
                    if let endpoint {
                        NavigationLink(value: endpoint) {
                            TitleView(title: title, subtitle: subtitle, showChevron: true)
                        }
                        .buttonStyle(.plain)
                    } else {
                        NavigationLink(value: [title: items]) {
                            TitleView(title: title, subtitle: subtitle, showChevron: true)
                        }
                        .buttonStyle(.plain)
                    }
#endif
                    ScrollView(.horizontal, showsIndicators: false) {
#if !os(tvOS)
                        switch settings.listsDisplayType {
                        case .standard:
                            LazyHStack {
                                if displayAsCard {
                                    cardStyle
                                } else {
                                    posterStyle
                                }
                            }
                        case .card: cardStyle
                        case .poster: posterStyle
                        }
#else
                        cardStyle
#endif
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var cardStyle: some View {
        if let items {
            LazyHStack {
                ForEach(items) { item in
                    CardFrame(item: item, showConfirmation: $addedItemConfirmation)
#if !os(tvOS)
                        .padding([.leading, .trailing], 4)
                        .padding(.leading, item.id == items.first!.id ? 16 : 0)
                        .padding(.trailing, item.id == items.last!.id ? 16 : 0)
#else
                        .padding([.leading, .trailing], 2)
                        .padding(.leading, item.id == items.first!.id ? 32 : 0)
                        .padding(.trailing, item.id == items.last!.id ? 32 : 0)
#endif
                        .buttonStyle(.plain)
                        .padding(.top, 8)
                        .padding(.bottom)
                }
            }
        }
    }
    
    @ViewBuilder
    private var posterStyle: some View {
        if let items {
            LazyHStack {
                ForEach(items) { item in
                    Poster(item: item,
                           addedItemConfirmation: $addedItemConfirmation)
#if !os(tvOS)
                    .padding([.leading, .trailing], settings.isCompactUI ? 1 : 4)
                    .padding(.leading, item.id == items.first!.id ? 16 : 0)
                    .padding(.trailing, item.id == items.last!.id ? 16 : 0)
                    .padding(.top, settings.isCompactUI ? 4 : 8)
                    .padding(.bottom, settings.isCompactUI ? 4 : nil)
#else
                    .padding([.leading, .trailing], 2)
                    .padding(.leading, item.id == items.first!.id ? 32 : 0)
                    .padding(.trailing, item.id == items.last!.id ? 32 : 0)
                    .padding(.vertical)
#endif
                }
            }
#if os(tvOS)
            .padding(.vertical)
#endif
        }
    }
}

struct ItemContentListView_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalItemContentListView(items: ItemContent.examples,
                                      title: "Favorites",
                                      subtitle: "Favorites Movies",
                                      addedItemConfirmation: .constant(false))
    }
}

