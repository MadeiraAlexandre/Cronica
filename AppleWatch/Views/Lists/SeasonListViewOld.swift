//
//  SeasonListView.swift
//  CronicaWatch Watch App
//
//  Created by Alexandre Madeira on 27/09/22.
//

import SwiftUI

struct SeasonListView: View {
    var numberOfSeasons: [Season]
    var id: Int
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                List {
                    ForEach(numberOfSeasons, id: \.self) { season in
                        if season.seasonNumber != 0 {
                            NavigationLink("Season \(season.seasonNumber)", value: season)
                        }
                    }
                }
                .onAppear {
                    let contentId = "\(id)@\(MediaType.tvShow.toInt)"
                    let lastSeason = PersistenceController.shared.getLastSelectedSeason(contentId)
                    guard let lastSeason else { return }
                    withAnimation { proxy.scrollTo(lastSeason, anchor: .topLeading) }
                }
            }
        }
        .navigationTitle("Seasons")
    }
}