//
//  SearchView.swift
//  Story
//
//  Created by Alexandre Madeira on 02/03/22.
//

import SwiftUI

struct SearchView: View { 
    static let tag: Screens? = .search
    @StateObject private var viewModel: SearchViewModel
    @State private var showConfirmation: Bool = false
    private let context = PersistenceController.shared
    @State private var scope: SearchItemsScope = .noScope
    init() {
        _viewModel = StateObject(wrappedValue: SearchViewModel())
    }
    var body: some View {
        AdaptableNavigationView {
            ZStack {
                List {
                    switch scope {
                    case .noScope:
                        ForEach(viewModel.searchItems) { item in
                            SearchItemView(item: item, showConfirmation: $showConfirmation)
                                .draggable(item)
                        }
                    case .movies:
                        ForEach(viewModel.searchItems.filter { $0.itemContentMedia == .movie }) { item in
                            SearchItemView(item: item, showConfirmation: $showConfirmation)
                                .draggable(item)
                        }
                    case .shows:
                        ForEach(viewModel.searchItems.filter { $0.itemContentMedia == .tvShow && $0.media != .person }) { item in
                            SearchItemView(item: item, showConfirmation: $showConfirmation)
                                .draggable(item)
                        }
                    case .people:
                        ForEach(viewModel.searchItems.filter { $0.media == .person }) { item in
                            SearchItemView(item: item, showConfirmation: $showConfirmation)
                                .draggable(item)
                        }
                    }
                }
                .navigationTitle("Search")
                .navigationBarTitleDisplayMode(.large)
                .navigationDestination(for: Person.self) { person in
                    PersonDetailsView(title: person.name, id: person.id)
                }
                .navigationDestination(for: ItemContent.self) { item in
                    if item.media == .person {
                        PersonDetailsView(title: item.itemTitle, id: item.id)
                    } else {
                        ItemContentView(title: item.itemTitle, id: item.id, type: item.media)
                    }
                }
                .searchable(text: $viewModel.query,
                            placement: .navigationBarDrawer(displayMode: .always),
                            prompt: Text("Movies, Shows, People"))
                .searchScopes($scope) {
                    ForEach(SearchItemsScope.allCases) { scope in
                        Text(scope.localizableTitle).tag(scope)
                    }
                }
                .disableAutocorrection(true)
                .overlay(overlayView)
                .onAppear {
                    viewModel.observe()
                }
                ConfirmationDialogView(showConfirmation: $showConfirmation)
            }
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch viewModel.phase {
        case .empty:
            if !viewModel.trimmedQuery.isEmpty {
                VStack {
                    ProgressView("Searching")
                        .foregroundColor(.secondary)
                        .padding()
                }
            } else {
                VStack {
                    Spacer()
                    AttributionView() 
                }
            }
        case .success(let values) where values.isEmpty:
            Label("No Results", systemImage: "minus.magnifyingglass")
                .font(.title)
                .foregroundColor(.secondary)
        case .failure(_):
            EmptyView()
        default: EmptyView()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}