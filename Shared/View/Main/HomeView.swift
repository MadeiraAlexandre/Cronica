//
//  HomeView.swift
//  Story
//
//  Created by Alexandre Madeira on 10/02/22.
//

import SwiftUI

struct HomeView: View {
    static let tag: Screens? = .home
    @AppStorage("showOnboarding") var displayOnboard = true
    @StateObject private var viewModel: HomeViewModel
    @StateObject private var settings: SettingsStore
    @State private var showSettings = false
    @State private var isLoading = true
    @State private var showConfirmation = false
    init() {
        _viewModel = StateObject(wrappedValue: HomeViewModel())
        _settings = StateObject(wrappedValue: SettingsStore())
    }
    var body: some View {
        AdaptableNavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        WatchListUpcomingMoviesListView()
                        WatchListUpcomingSeasonsListView()
                        ItemContentListView(items: viewModel.trendingItems,
                                            title: "Trending",
                                            subtitle: "This week",
                                            image: "crown",
                                            addedItemConfirmation: $showConfirmation)
                        ForEach(viewModel.sectionsItems) { section in
                            ItemContentListView(items: section.results,
                                                title: section.title,
                                                subtitle: section.subtitle,
                                                image: section.image,
                                                addedItemConfirmation: $showConfirmation)
                        }
                        AttributionView()
                    }
                    .navigationDestination(for: ItemContent.self) { item in
                        ItemContentView(title: item.itemTitle, id: item.id, type: item.itemContentMedia)
                    }
                    .navigationDestination(for: Person.self) { person in
                        PersonDetailsView(title: person.name, id: person.id)
                    }
                    .navigationDestination(for: WatchlistItem.self) { item in
                        ItemContentView(title: item.itemTitle, id: item.itemId, type: item.itemMedia)
                    }
                    .redacted(reason: isLoading ? .placeholder : [] )
                    .navigationTitle("Home")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                HapticManager.shared.softHaptic()
                                showSettings.toggle()
                            }, label: {
                                Label("Settings", systemImage: "gearshape")
                            })
                        }
                    }
                    .sheet(isPresented: $displayOnboard) {
                        WelcomeView()
                    }
                    .sheet(isPresented: $showSettings) {
                        SettingsView(showSettings: $showSettings)
                            .environmentObject(settings)
                    }
                    .task { load() }
                }
                ConfirmationDialogView(showConfirmation: $showConfirmation)
            }
        }
    }
    
    private func load() {
        Task {
            await viewModel.load()
            withAnimation {
                isLoading = false
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
