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
    @State private var isSharePresented: Bool = false
    @State private var shareItems: [Any] = []
    @State private var isInWatchlist: Bool = false
    private let context = PersistenceController.shared
    @Binding var showConfirmation: Bool
    var body: some View {
        NavigationLink(destination: ItemContentView(title: item.itemTitle, id: item.id, type: item.itemContentMedia)) {
            WebImage(url: item.posterImageMedium, options: .highPriority)
                .placeholder {
                    ZStack {
                        Rectangle().fill(.thickMaterial)
                        VStack {
                            Text(item.itemTitle)
                                .lineLimit(1)
                                .padding(.bottom)
                            Image(systemName: "film")
                        }
                        .padding()
                        .foregroundColor(.secondary)
                    }
                    .frame(width: DrawingConstants.posterWidth,
                           height: DrawingConstants.posterHeight)
                    .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.posterRadius,
                                                style: .continuous))
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .transition(.fade(duration: 0.5))
                .frame(width: DrawingConstants.posterWidth,
                       height: DrawingConstants.posterHeight)
                .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.posterRadius,
                                            style: .continuous))
                .contextMenu {
                    Button(action: {
                        HapticManager.shared.softHaptic()
                        shareItems = [item.itemURL]
                        isSharePresented.toggle()
                    }, label: {
                        Label("Share",
                              systemImage: "square.and.arrow.up")
                    })
                    Button(action: {
                        Task {
                            updateWatchlist(with: item)
                        }
                    }, label: {
                        Label("Add to watchlist", systemImage: "plus.circle")
                    })
                    
                }
                .sheet(isPresented: $isSharePresented,
                       content: { ActivityViewController(itemsToShare: $shareItems) })
                .shadow(color: .black.opacity(DrawingConstants.shadowOpacity),
                        radius: DrawingConstants.shadowRadius)
                .padding([.leading, .trailing], 4)
        }
        .buttonStyle(.plain)
        
    }
    
    private func updateWatchlist(with item: ItemContent) {
        HapticManager.shared.softHaptic()
        if !context.isItemInList(id: item.id, type: item.itemContentMedia) {
            Task {
                let content = try? await NetworkService.shared.fetchContent(id: item.id, type: item.itemContentMedia)
                if let content = content {
                    withAnimation {
                        self.context.saveItem(content: content, notify: content.itemCanNotify)
                        showConfirmation.toggle()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                            showConfirmation = false
                        }
                    }
                }
            }
        }
    }
}

struct PosterView_Previews: PreviewProvider {
    @State private static var show = false
    static var previews: some View {
        PosterView(item: ItemContent.previewContent, showConfirmation: $show)
    }
}

private struct DrawingConstants {
    static let posterWidth: CGFloat = 160
    static let posterHeight: CGFloat = 240
    static let posterRadius: CGFloat = 8
    static let shadowOpacity: Double = 0.5
    static let shadowRadius: CGFloat = 2.5
}
