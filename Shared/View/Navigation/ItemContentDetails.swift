//
//  ItemContentDetails.swift
//  Story
//
//  Created by Alexandre Madeira on 02/03/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ItemContentDetails: View {
    var title: String
    var id: Int
    var type: MediaType
    let itemUrl: URL
    @StateObject private var viewModel: ItemContentViewModel
    @StateObject private var store: SettingsStore
    @State private var showConfirmation = false
    @State private var showSeasonConfirmation = false
    @State private var switchMarkAsView = false
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    init(title: String, id: Int, type: MediaType) {
        _viewModel = StateObject(wrappedValue: ItemContentViewModel(id: id, type: type))
        _store = StateObject(wrappedValue: SettingsStore())
        self.title = title
        self.id = id
        self.type = type
        self.itemUrl = URL(string: "https://www.themoviedb.org/\(type.rawValue)/\(id)")!
    }
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
                    .foregroundColor(.secondary)
            }
            VStack {
                ScrollView {
                    CoverImageView(title: title)
                        .environmentObject(viewModel)
                    
                    if UIDevice.isIPhone {
                        WatchlistButtonView()
                            .keyboardShortcut("l", modifiers: [.option])
                            .environmentObject(viewModel)
                    } else {
                        ViewThatFits {
                            HStack {
                                WatchlistButtonView()
                                    .keyboardShortcut("l", modifiers: [.option])
                                    .environmentObject(viewModel)
                                    .padding(.horizontal)
                                MarkAsMenuView()
                                    .environmentObject(viewModel)
                                    .buttonStyle(.bordered)
                                    .buttonBorderShape(.capsule)
                                    .controlSize(.large)
                                    .padding(.trailing)
                            }
                            .padding([.top, .bottom])
                            WatchlistButtonView()
                                .keyboardShortcut("l", modifiers: [.option])
                                .environmentObject(viewModel)
                        }
                    }
                    
                    OverviewBoxView(overview: viewModel.content?.itemOverview,
                                    title: title)
                    .padding()
                    
                    TrailerListView(trailers: viewModel.content?.itemTrailers)
                    
                    SeasonListView(numberOfSeasons: viewModel.content?.itemSeasons,
                                tvId: id,
                                inWatchlist: $viewModel.isInWatchlist,
                                seasonConfirmation: $showSeasonConfirmation)
                    .padding(0)
                    
                    CastListView(credits: viewModel.credits)
                    
                    ItemContentListView(items: viewModel.recommendations,
                                        title: "Recommendations",
                                        subtitle: "You may like",
                                        image: "list.and.film",
                                        addedItemConfirmation: $showConfirmation,
                                        displayAsCard: true)
                    
                    InformationSectionView(item: viewModel.content)
                        .padding()
                    
                    AttributionView()
                        .padding([.top, .bottom])
                }
            }
            .background {
                TranslucentBackground(image: viewModel.content?.cardImageLarge)
            }
            .task {
                await viewModel.load()
            }
            .redacted(reason: viewModel.isLoading ? .placeholder : [])
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem {
                    HStack {
                        Image(systemName: viewModel.hasNotificationScheduled ? "bell.fill" : "bell")
                            .opacity(viewModel.isNotificationAvailable ? 1 : 0)
                            .foregroundColor(.accentColor)
                            .accessibilityHidden(true)
                        ShareLink(item: itemUrl)
                            .disabled(viewModel.isLoading ? true : false)
                        if UIDevice.isIPhone {
                            MarkAsMenuView()
                                .environmentObject(viewModel)
                        }
                    }
                }
            }
            .alert("Error",
                   isPresented: $viewModel.showErrorAlert,
                   actions: {
                Button("Cancel") {
                    
                }
                Button("Retry") {
                    Task {
                        await viewModel.load()
                    }
                }
            }, message: {
                Text(viewModel.errorMessage)
            })
            ConfirmationDialogView(showConfirmation: $showConfirmation)
            ConfirmationDialogView(showConfirmation: $showSeasonConfirmation,
                                   message: "Season Marked as Watched", image: "tv.fill")
        }
    }
}

struct ItemContentDetails_Previews: PreviewProvider {
    static var previews: some View {
        ItemContentDetails(title: ItemContent.previewContent.itemTitle,
                        id: ItemContent.previewContent.id,
                        type: MediaType.movie)
    }
}