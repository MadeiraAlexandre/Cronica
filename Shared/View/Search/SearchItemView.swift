//
//  SearchItemView.swift
//  Story (iOS)
//
//  Created by Alexandre Madeira on 30/05/22.
//

import SwiftUI

struct SearchItemView: View {
    let item: ItemContent
    @Binding var showConfirmation: Bool
    @State private var isSharePresented: Bool = false
    @State private var shareItems: [Any] = []
    private let context = PersistenceController.shared
    var body: some View {
        if item.media == .person {
            NavigationLink(destination: PersonDetailsView(title: item.itemTitle, id: item.id)) {
                SearchItem(item: item)
                    .contextMenu {
                        Button(action: {
                            HapticManager.shared.softHaptic()
                            shareItems = [item.itemSearchURL]
                            isSharePresented.toggle()
                        }, label: {
                            Label("Share",
                                  systemImage: "square.and.arrow.up")
                        })
                    }
                    .sheet(isPresented: $isSharePresented,
                           content: { ActivityViewController(itemsToShare: $shareItems) })
            }
        } else {
            NavigationLink(destination: ItemContentView(title: item.itemTitle, id: item.id, type: item.itemContentMedia)) {
                SearchItem(item: item)
                    .contextMenu {
                        Button(action: {
                            HapticManager.shared.softHaptic()
                            shareItems = [item.itemSearchURL]
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
            }
        }
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

struct SearchItemView_Previews: PreviewProvider {
    @State private static var show: Bool = false
    static var previews: some View {
        SearchItemView(item: ItemContent.previewContent, showConfirmation: $show)
    }
}

private struct SearchItem: View {
    let item: ItemContent
    @State private var isSharePresented: Bool = false
    @State private var shareItems: [Any] = []
    private let context = PersistenceController.shared
    var body: some View {
        HStack {
            if item.media == .person {
                AsyncImage(url: item.itemImage,
                           transaction: Transaction(animation: .easeInOut)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .transition(.opacity)
                    } else if phase.error != nil {
                        ZStack {
                            ProgressView()
                        }.background(.secondary)
                    } else {
                        ZStack {
                            Color.secondary
                            Image(systemName: "person")
                        }
                    }
                }
                .frame(width: DrawingConstants.personImageWidth,
                       height: DrawingConstants.personImageHeight)
                .clipShape(Circle())
            } else {
                AsyncImage(url: item.itemImage,
                           transaction: Transaction(animation: .easeInOut)) { phase in
                    if let image = phase.image {
                        ZStack {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .transition(.opacity)
                        }
                    } else if phase.error != nil {
                        ZStack {
                            Color.secondary
                            ProgressView()
                        }
                    } else {
                        ZStack {
                            Color.secondary
                            Image(systemName: "film")
                        }
                    }
                }
                .frame(width: DrawingConstants.imageWidth,
                       height: DrawingConstants.imageHeight)
                .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.imageRadius))
            }
            VStack(alignment: .leading) {
                HStack {
                    Text(item.itemTitle)
                        .lineLimit(DrawingConstants.textLimit)
                }
                HStack {
                    Text(item.media.title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
        .accessibilityElement(children: .combine)
    }
}

private struct DrawingConstants {
    static let imageWidth: CGFloat = 70
    static let imageHeight: CGFloat = 50
    static let imageRadius: CGFloat = 4
    static let textLimit: Int = 1
    static let personImageWidth: CGFloat = 60
    static let personImageHeight: CGFloat = 60
}
