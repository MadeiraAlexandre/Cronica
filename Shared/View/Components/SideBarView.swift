//
//  SideBarView.swift
//  Story (iOS)
//
//  Created by Alexandre Madeira on 28/04/22.
//

import SwiftUI

struct SideBarView: View {
    @SceneStorage("selectedView") var selectedView: Screens?
    @ViewBuilder
    var body: some View {
        NavigationView {
            List(selection: $selectedView) {
                NavigationLink(destination: HomeView()) {
                    Label("Home", systemImage: "house")
                }.tag(HomeView.tag)
                NavigationLink(destination: DiscoverView()) {
                    Label("Explore", systemImage: "film")
                }.tag(DiscoverView.tag)
                NavigationLink(destination: WatchlistView()) {
                    Label("Watchlist", systemImage: "square.stack.fill")
                }.tag(WatchlistView.tag)
                NavigationLink(destination: SearchView()) {
                    Label("Search", systemImage: "magnifyingglass")
                }.tag(SearchView.tag)
            }
            .listStyle(SidebarListStyle())
            .navigationTitle("Cronica")
            switch selectedView {
            case .discover: DiscoverView()
            case .watchlist: WatchlistView()
            case .search: SearchView()
            default: HomeView()
            }
        }
        .navigationViewStyle(.columns)
    }
}

struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarView()
    }
}
