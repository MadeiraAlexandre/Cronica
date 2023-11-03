//
//  PersonSearchImage.swift
//  CronicaMac
//
//  Created by Alexandre Madeira on 20/11/22.
//

import SwiftUI
import SDWebImageSwiftUI

/// A rectangular shape for displaying Person images in Search, it is currently used
/// for displaying people in Search for macOS. This is a simpler view from the Cast List.
struct PersonSearchImage: View {
    let item: SearchItemContent
    @FocusState var isStackFocused: Bool
#if os(macOS)
    @State private var isOnHover = false
#endif
    var body: some View {
        VStack(alignment: .leading) {
            image
#if os(tvOS) || os(macOS)
            HStack {
                Text(item.itemTitle)
                    .padding(.top, 4)
                    .font(.caption)
                    .lineLimit(2)
#if os(tvOS)
                    .foregroundStyle(isStackFocused ? .primary : .secondary)
#elseif os(macOS)
                    .foregroundStyle(isOnHover ? .primary : .secondary)
#endif
                    .frame(maxWidth: DrawingConstants.posterWidth)
                Spacer()
            }
            Spacer()
#endif
        }
#if os(tvOS)
        .focused($isStackFocused)
        .buttonStyle(.card)
#elseif os(macOS)
        .onHover { onHover in
            isOnHover = onHover
        }
#endif
    }
    
    private var image: some View {
        NavigationLink(value: item) {
            WebImage(url: item.itemImage, options: .highPriority)
                .resizable()
                .placeholder { placeholder }
                .aspectRatio(contentMode: .fill)
                .transition(.opacity)
                .frame(width: DrawingConstants.posterWidth,
                       height: DrawingConstants.posterHeight)
                .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.posterRadius,
                                            style: .continuous))
                .shadow(radius: DrawingConstants.shadowRadius)
                .padding(.zero)
#if os(macOS) || os(iOS)
                .contextMenu { ShareLink(item: item.itemSearchURL) }
#elseif os(tvOS)
                .buttonStyle(.card)
#endif
        }
    }
    
    private var placeholder: some View {
        ZStack {
            Rectangle().fill(.gray.gradient)
            Image(systemName: "person")
                .font(.title)
                .foregroundColor(.secondary)
        }
        .frame(width: DrawingConstants.posterWidth,
               height: DrawingConstants.posterHeight)
        .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.posterRadius,
                                    style: .continuous))
        .shadow(radius: DrawingConstants.shadowRadius)
        .padding(.zero)
    }
}

private struct DrawingConstants {
#if os(tvOS)
    static let posterWidth: CGFloat = 260
    static let posterHeight: CGFloat = 380
#else
    static let posterWidth: CGFloat = 160
    static let posterHeight: CGFloat = 240
#endif
    static let posterRadius: CGFloat = 8
    static let shadowRadius: CGFloat = 2.5
}
