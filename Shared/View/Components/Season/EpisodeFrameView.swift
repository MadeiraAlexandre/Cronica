//
//  EpisodeFrameView.swift
//  Story (iOS)
//
//  Created by Alexandre Madeira on 10/05/22.
//

import SwiftUI
import SDWebImageSwiftUI

/// A view that displays a frame with an image, episode number, title, and two line overview,
/// on tap it display a sheet view with more information.
struct EpisodeFrameView: View {
    let episode: Episode
    let season: Int
    let show: Int
    var itemLink: URL
    private let persistence = PersistenceController.shared
    @AppStorage("markEpisodeWatchedTap") private var episodeTap = false
    @State private var isWatched = false
    @State private var showDetails = false
    @Binding var isInWatchlist: Bool
    @EnvironmentObject var viewModel: SeasonViewModel
    init(episode: Episode, season: Int, show: Int, isInWatchlist: Binding<Bool>) {
        self.episode = episode
        self.season = season
        self.show = show
        self._isInWatchlist = isInWatchlist
        itemLink = URL(string: "https://www.themoviedb.org/tv/\(show)/season/\(season)/episode/\(episode.episodeNumber ?? 1)")!
    }
    var body: some View {
        VStack {
            WebImage(url: episode.itemImageMedium)
                .placeholder {
                    ZStack {
                        Rectangle().fill(.thickMaterial)
                        VStack {
                            Text(episode.itemTitle)
                                .font(.callout)
                                .lineLimit(1)
                                .padding(.bottom)
                            Image(systemName: "tv")
                        }
                        .padding()
                        .foregroundColor(.secondary)
                    }
                    .frame(width: DrawingConstants.imageWidth,
                           height: DrawingConstants.imageHeight)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .transition(.opacity)
                .frame(width: DrawingConstants.imageWidth,
                       height: DrawingConstants.imageHeight)
                .clipShape(
                    RoundedRectangle(cornerRadius: DrawingConstants.imageRadius,
                                     style: .continuous)
                )
                .overlay {
                    if isWatched {
                        ZStack {
                            Color.black.opacity(0.4)
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                                .opacity(0.8)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.imageRadius, style: .continuous))
                        .frame(width: DrawingConstants.imageWidth,
                               height: DrawingConstants.imageHeight)
                    }
                }
                .contextMenu {
                    WatchEpisodeButtonView(episode: episode,
                                           season: season,
                                           show: show,
                                           isWatched: $isWatched,
                                           inWatchlist: $isInWatchlist)
                    if let number = episode.episodeNumber {
                        if number != 1 && !isWatched {
                            Button("Mark this and previous episodes as watched") {
                                Task {
                                    await viewModel.markThisAndPrevious(until: episode.id, show: show)
                                }
                            }
                        }
                    }
                    ShareLink(item: itemLink)
                }
                .applyHoverEffect()
            HStack {
                Text("Episode \(episode.episodeNumber ?? 0)")
                    .font(.caption2)
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.top, 1)
            HStack {
                Text(episode.itemTitle)
                    .font(.callout)
                    .lineLimit(1)
                Spacer()
            }
            HStack {
                Text(episode.itemOverview)
                    .font(.caption)
                    .lineLimit(2)
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .task {
            withAnimation {
                isWatched = persistence.isEpisodeSaved(show: show, season: season, episode: episode.id)
            }
        }
        .onTapGesture {
#if os(macOS)
            markAsWatched()
#else
            if episodeTap {
                markAsWatched()
                return
            }
            showDetails.toggle()
#endif
        }
        .sheet(isPresented: $showDetails) {
            NavigationStack {
                EpisodeDetailsView(episode: episode, season: season, show: show, isWatched: $isWatched, isInWatchlist: $isInWatchlist)
                    .environmentObject(viewModel)
                    .toolbar {
                        ToolbarItem {
                            Button("Done") {
                                showDetails = false
                            }
                        }
                    }
#if os(macOS)
                    .frame(width: 900, height: 500)
#endif
            }
        }
    }
    
    private func markAsWatched() {
        PersistenceController.shared.updateEpisodeList(show: show,
                                                       season: season,
                                                       episode: episode.id)
        withAnimation {
            isWatched.toggle()
        }
    }
}

private struct DrawingConstants {
    static let imageWidth: CGFloat = 160
    static let imageHeight: CGFloat = 100
    static let imageRadius: CGFloat = 8
    static let titleLineLimit: Int = 1
}
