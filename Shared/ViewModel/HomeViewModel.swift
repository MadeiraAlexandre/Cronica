//
//  HomeViewModel.swift
//  Story
//
//  Created by Alexandre Madeira on 02/03/22.
//

import Foundation
import CoreData

@MainActor
class HomeViewModel: ObservableObject {
    private let service: NetworkService = NetworkService.shared
    @Published var trendingItems: [ItemContent]?
    @Published var sectionsItems: [ItemContentSection] = []
    @Published var upcomingSection: ItemContentSection?
    @Published var nowPlayingSection: ItemContentSection?
    
    func load() async {
        Task {
            if trendingItems == nil {
                let result = try? await service.fetchContents(from: "trending/all/week")
                if let result = result {
                    let trending = result.filter { $0.itemContentMedia != .person }
                    trendingItems = trending
                }
            }
            if upcomingSection == nil {
                let upcoming = try? await service.fetchContents(from: "\(MediaType.movie.rawValue)/\(Endpoints.upcoming.rawValue)")
                if let upcoming = upcoming {
                    let section = ItemContentSection.init(results: upcoming, endpoint: Endpoints.upcoming)
                    upcomingSection = section
                }
            }
            if nowPlayingSection == nil {
                let nowPlaying = try? await service.fetchContents(from: "\(MediaType.movie.rawValue)/\(Endpoints.nowPlaying.rawValue)")
                if let nowPlaying = nowPlaying {
                    let section = ItemContentSection.init(results: nowPlaying, endpoint: Endpoints.nowPlaying)
                    nowPlayingSection = section
                }
            }
        }
    }
}
