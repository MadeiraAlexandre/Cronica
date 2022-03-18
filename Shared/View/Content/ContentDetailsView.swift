//
//  ContentDetailsView.swift
//  Story
//
//  Created by Alexandre Madeira on 02/03/22.
//

import SwiftUI

struct ContentDetailsView: View {
    var title: String
    var id: Int
    var type: MediaType
    @StateObject private var viewModel: ContentDetailsViewModel
    @ObservedObject private var settings: SettingsStore = SettingsStore()
    @State private var isAboutPresented: Bool = false
    @State private var isSharePresented: Bool = false
    @State private var isNotificationAvailable: Bool = false
    @State private var isNotificationEnabled: Bool = false
    @State private var isAdded: Bool = false
    init(title: String, id: Int, type: MediaType) {
        _viewModel = StateObject(wrappedValue: ContentDetailsViewModel())
        self.title = title
        self.id = id
        self.type = type
    }
    var body: some View {
        ScrollView {
            VStack {
                if let content = viewModel.content {
                    HeroImageView(title: content.itemTitle, url: content.cardImageLarge)
                    if !content.itemInfo.isEmpty {
                        Text(content.itemInfo)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .onAppear {
                                if !content.isReleased { isNotificationAvailable.toggle() }
                                print("Is \(content.itemTitle) released? \(content.isReleased). \(content.itemReleaseDate)")
                            }
                    }
                    //MARK: Watchlist button
                    Button {
#if os(iOS)
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred(intensity: 1.0)
#endif
                        if !viewModel.inWatchlist {
                            if settings.isAutomaticallyNotification {
                                isNotificationEnabled.toggle()
                            }
                            viewModel.add()
                            withAnimation {
                                isAdded.toggle()
                            }
                        } else {
                            viewModel.remove()
                            withAnimation {
                                isAdded.toggle()
                            }
                        }
                    } label: {
                        withAnimation {
                            Label(!isAdded ? "Add to watchlist" : "Remove from watchlist", systemImage: !isAdded ? "plus.square" : "minus.square")
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(!isAdded ? .blue : .red)
                    .controlSize(.large)
                    //MARK: About view
                    GroupBox {
                        Text(content.itemAbout)
                            .padding([.top], 2)
                            .textSelection(.enabled)
                            .lineLimit(4)
                    } label: {
                        Label("About", systemImage: "film")
                    }
                    .padding()
                    .onTapGesture {
                        isAboutPresented.toggle()
                    }
                    .sheet(isPresented: $isAboutPresented) {
                        NavigationView {
                            ScrollView {
                                Text(content.itemAbout).padding()
                            }
                            .navigationTitle(content.itemTitle)
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button("Done") {
                                        isAboutPresented.toggle()
                                    }
                                }
                            }
                        }
                    }
                    if content.seasonsNumber > 0 {
                        SeasonListView(title: "Seasons", id: id, items: content.seasons!)
                    }
                    if content.credits != nil {
                        PersonListView(credits: content.credits!)
                    }
                    InformationView(item: content)
                    if content.recommendations != nil {
                        ContentListView(style: StyleType.poster,
                                        type: content.itemContentMedia,
                                        title: "Recommendations",
                                        items: content.recommendations!.results)
                    }
                    AttributionView().padding([.top, .bottom])
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem {
                    HStack {
                        Button( action: {
                            NotificationManager.shared.requestAuthorization { granted in
                                if granted {
                                    
                                }
                            }
                            isNotificationEnabled.toggle()
                        }, label: {
                            withAnimation {
                                Image(systemName: isNotificationEnabled ? "bell.fill" : "bell")
                            }
                        })
                        .help("Notify when released.")
                        .opacity(isNotificationAvailable ? 1 : 0)
                        Button(action: {
                            isSharePresented.toggle()
                        }, label: {
                            Image(systemName: "square.and.arrow.up")
                        })
                    }
                }
            }
            .sheet(isPresented: $isSharePresented, content: { ActivityViewController(itemsToShare: [title]) })
        }
        .task {
            load()
        }
    }
    
    @Sendable
    private func load() {
        Task {
            await self.viewModel.load(id: self.id, type: self.type)
            isAdded = viewModel.inWatchlist
        }
    }
}

struct ContentDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailsView(title: Content.previewContent.itemTitle,
                           id: Content.previewContent.id,
                           type: MediaType.movie)
    }
}
