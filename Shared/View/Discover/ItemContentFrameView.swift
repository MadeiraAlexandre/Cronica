//
//  ItemContentFrameView.swift
//  Story (iOS)
//
//  Created by Alexandre Madeira on 07/06/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ItemContentFrameView: View {
    let item: ItemContent
    @Binding var showConfirmation: Bool
    @State private var isSharePresented: Bool = false
    @State private var shareItems: [Any] = []
    private let context = PersistenceController.shared
    var body: some View {
        NavigationLink(destination: ItemContentView(title: item.itemTitle, id: item.id, type: item.itemContentMedia)) {
            VStack {
                WebImage(url: item.cardImageMedium, options: .highPriority)
                    .placeholder {
                        ZStack {
                            Rectangle().fill(.thickMaterial)
                            VStack {
                                ProgressView()
                                    .padding(.bottom)
                                Image(systemName: "film")
                            }
                            .padding()
                            .foregroundColor(.secondary)
                        }
                        .frame(width: UIDevice.isIPad ? DrawingConstants.padImageWidth :  DrawingConstants.imageWidth,
                               height: UIDevice.isIPad ? DrawingConstants.padImageHeight : DrawingConstants.imageHeight)
                        .clipShape(RoundedRectangle(cornerRadius: UIDevice.isIPad ? DrawingConstants.padImageRadius : DrawingConstants.imageRadius,
                                                    style: .continuous))
                    }
                    .resizable()
                    .transition(.fade(duration: 0.5))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIDevice.isIPad ? DrawingConstants.padImageWidth :  DrawingConstants.imageWidth,
                           height: UIDevice.isIPad ? DrawingConstants.padImageHeight : DrawingConstants.imageHeight)
                    .clipShape(RoundedRectangle(cornerRadius: UIDevice.isIPad ? DrawingConstants.padImageRadius : DrawingConstants.imageRadius,
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
                    .shadow(radius: DrawingConstants.imageShadow)
                HStack {
                    Text(item.itemTitle)
                        .font(.caption)
                        .lineLimit(DrawingConstants.titleLineLimit)
                    Spacer()
                }
                .frame(width: UIDevice.isIPad ? DrawingConstants.padImageWidth : DrawingConstants.imageWidth)
            }
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

struct ItemContentFrameView_Previews: PreviewProvider {
    @State private static var show = false
    static var previews: some View {
        ItemContentFrameView(item: ItemContent.previewContent,
                             showConfirmation: $show)
    }
}


private struct DrawingConstants {
    static let imageWidth: CGFloat = 160
    static let imageHeight: CGFloat = 100
    static let imageRadius: CGFloat = 8
    static let imageShadow: CGFloat = 2.5
    static let padImageWidth: CGFloat = 240
    static let padImageHeight: CGFloat = 140
    static let padImageRadius: CGFloat = 12
    static let titleLineLimit: Int = 1
}
