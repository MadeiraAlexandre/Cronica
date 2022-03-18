//
//  PersonView.swift
//  Story
//
//  Created by Alexandre Madeira on 29/01/22.
//

import SwiftUI

struct PersonView: View {
    let title: String
    let id: Int
    @State private var showingOverview: Bool = false
    @StateObject private var viewModel: PersonViewModel
    init(title: String, id: Int) {
        _viewModel = StateObject(wrappedValue: PersonViewModel())
        self.title = title
        self.id = id
    }
    var body: some View {
        ScrollView {
            if let person = viewModel.person {
                VStack {
                    AsyncImage(url: person.mediumImage) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView(title)
                    }
                    .frame(width: DrawingConstants.imageWidth,
                           height: DrawingConstants.imageHeight)
                    .clipShape(Circle())
                    .padding([.top, .bottom])
#if os(tvOS)
#else
                    if !person.personBiography.isEmpty {
                        GroupBox {
                            Text(person.personBiography)
                                .padding([.top, .bottom],
                                         DrawingConstants.biographyPadding)
                                .lineLimit(DrawingConstants.biographyLineLimits)
                        } label: {
                            Label("Biography", systemImage: "book")
                        }
                        .onTapGesture {
                            showingOverview.toggle()
                        }
                        .padding()
                        .sheet(isPresented: $showingOverview) {
                            NavigationView {
                                ScrollView {
                                    Text(person.personBiography)
                                        .padding()
                                }
                                .navigationTitle(title)
#if os(iOS)
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button("Done") {
                                            showingOverview.toggle()
                                        }
                                    }
                                }
#endif
                            }
                        }
                    }
#endif
                    if person.combinedCredits != nil {
                        FilmographyListView(filmography: (person.combinedCredits?.cast)!)
                    }
                    AttributionView().padding([.top, .bottom])
                }
            }
        }
        .navigationTitle(title)
        .task {
            load()
        }
    }
    
    @Sendable
    private func load() {
        Task {
            await self.viewModel.load(id: self.id)
        }
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        PersonView(title: Credits.previewCast.name,
                   id: Credits.previewCast.id)
    }
}

private struct DrawingConstants {
    static let imageWidth: CGFloat = 150
    static let imageHeight: CGFloat = 150
    static let biographyPadding: CGFloat = 4
    static let biographyLineLimits: Int = 4
    static let imageRadius: CGFloat = 12
}
