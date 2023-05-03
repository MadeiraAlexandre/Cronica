//
//  ItemContentView.swift
//  CronicaWatch Watch App
//
//  Created by Alexandre Madeira on 03/08/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ItemContentView: View {
    let id: Int
    let title: String
    let url: URL
    let image: URL?
    @StateObject private var viewModel: ItemContentViewModel
    @State private var showCustomListSheet = false
    init(id: Int, title: String, type: MediaType, image: URL?) {
        self.id = id
        self.title = title
        self.image = image
        _viewModel = StateObject(wrappedValue: ItemContentViewModel(id: id, type: type))
        self.url = URL(string: "https://www.themoviedb.org/\(type.rawValue)/\(id)")!
    }
    var body: some View {
        VStack {
            ScrollView {
                HeroImage(url: image, title: title)
                    .clipShape(
                        RoundedRectangle(cornerRadius: DrawingConstants.imageRadius,
                                         style: .continuous)
                    )
                    .padding()
                
                WatchlistButtonView()
                    .environmentObject(viewModel)
                    .padding()
                
                if let seasons = viewModel.content?.itemSeasons {
                    NavigationLink("Seasons", destination:  SeasonListView(numberOfSeasons: seasons, id: id, isInWatchlist: $viewModel.isInWatchlist))
                        .padding([.horizontal, .bottom])
                }   
                
                watchButton
                    .padding([.horizontal, .bottom])
                
                ShareLink(item: url)
                    .padding([.horizontal, .bottom])
                
                customListButton
                    .padding([.horizontal, .bottom])
                
                AboutSectionView(about: viewModel.content?.itemOverview)
                
                CompanionTextView()
                
                AttributionView()
            }
        }
        .task {
            await viewModel.load()
        }
        .navigationTitle(title)
        .redacted(reason: viewModel.isLoading ? .placeholder : [])
        .sheet(isPresented: $showCustomListSheet) {
            ItemContentCustomListSelector(item: $viewModel.watchlistItem,
                                          showView: $showCustomListSheet)
        }
    }
    
    private var watchButton: some View {
        Button {
            
            //viewModel.updateMarkAs(markAsWatched: !viewModel.isWatched)
        } label: {
            Label(viewModel.isWatched ? "Remove from Watched" : "Mark as Watched",
                  systemImage: viewModel.isWatched ? "minus.circle.fill" : "checkmark.circle.fill")
        }
        .buttonStyle(.bordered)
        .tint(viewModel.isWatched ? .yellow : .green)
        .controlSize(.large)
        .disabled(viewModel.isLoading)
    }
    
    private var customListButton: some View {
        Button {
            if viewModel.watchlistItem == nil {
                viewModel.fetchSavedItem()
            }
            showCustomListSheet.toggle()
        } label: {
            Label("addToCustomList", systemImage: "rectangle.on.rectangle.angled")
        }
        .disabled(!viewModel.isInWatchlist)
    }
}

struct ItemContentView_Previews: PreviewProvider {
    static var previews: some View {
        ItemContentView(id: ItemContent.previewContent.id,
                        title: ItemContent.previewContent.itemTitle,
                        type: ItemContent.previewContent.itemContentMedia,
                        image: ItemContent.previewContent.cardImageMedium)
    }
}

private struct DrawingConstants {
    static let imageRadius: CGFloat = 8
    static let lineLimit: Int = 1
}

private struct AddToCustomList {
    @Binding var showView: Bool
    @Binding var item: WatchlistItem?
    var body: some View {
        NavigationStack {
            Form {
                
            }
        }
    }
}
