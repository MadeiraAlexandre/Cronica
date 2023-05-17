//
//  TabBarView.swift
//  Story (iOS)
//
//  Created by Alexandre Madeira on 01/05/22.
//

import SwiftUI

/// A TabBar for switching views, only used on iPhone.
struct TabBarView: View {
    @AppStorage("selectedView") var selectedView: Screens?
    var persistence = PersistenceController.shared
    var body: some View {
#if os(iOS)
        iOSBarView
            .onAppear {
                let settings = SettingsStore.shared
                if settings.isPreferredLaunchScreenEnabled {
                    selectedView = settings.preferredLaunchScreen
                }
            }
#elseif os(tvOS)
        tvOSBarView
#endif
    }
    
#if os(tvOS)
    private var tvOSBarView: some View {
        TabView {
            
            NavigationStack { ExploreView() }
                .tag(ExploreView.tag)
                .tabItem { Label("Explore", systemImage: "popcorn") }
            
            NavigationStack {
                WatchlistView()
                    .environment(\.managedObjectContext, persistence.container.viewContext)
            }
            .tabItem { Label("Watchlist", systemImage: "square.stack") }
            
            NavigationStack { TVSearchView() }
                .tabItem { Label("Search", systemImage: "magnifyingglass").labelStyle(.iconOnly) }
        }
    }
#endif
    
#if os(iOS)
    private var iOSBarView: some View {
        TabView(selection: $selectedView) {
            NavigationStack { HomeView() }
                .tag(HomeView.tag)
                .tabItem { Label("Home", systemImage: "house") }
            
            NavigationStack { ExploreView() }
                .tag(ExploreView.tag)
                .tabItem { Label("Explore", systemImage: "popcorn") }
            
            NavigationStack {
                WatchlistView()
                    .environment(\.managedObjectContext, persistence.container.viewContext)
            }
            .tag(WatchlistView.tag)
            .tabItem { Label("Watchlist", systemImage: "square.stack") }
            
            NavigationStack { SearchView() }
                .tag(SearchView.tag)
                .tabItem { Label("Search", systemImage: "magnifyingglass") }
            
            SettingsView(showSettings: .constant(true))
                .tag(SettingsView.tag)
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
        .appTheme()
    }
#endif
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
