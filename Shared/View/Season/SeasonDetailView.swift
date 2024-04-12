//
//  SeasonDetailView.swift
//  Story (iOS)
//
//  Created by Alexandre Madeira on 11/04/24.
//

import SwiftUI
import NukeUI

struct SeasonDetailView: View {
    @StateObject private var settings: SettingsStore = .shared
    var item: Season
    var showID: Int
    @Binding var selectedSeasonDetails: Season?
    var body: some View {
        NavigationStack {
            Form {
                // header section for the season details
                Section {
                    VStack(alignment: .center) {
                        HStack(alignment: .center) {
                            LazyImage(url: item.seasonPosterUrl) { state in
                                if let image = state.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } else {
                                    ZStack {
                                        Rectangle().fill(.gray.gradient)
                                        Image(systemName: "tv")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50, alignment: .center)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .frame(width: 150, height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
                        }
                        .frame(maxWidth: .infinity)
                        
                        if let name = item.name {
                            Text(name)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                            Text("Season \(item.seasonNumber)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .fontWeight(.medium)
                        } else {
                            Text("Season \(item.seasonNumber)")
                        }
                        
                        if let release = item.itemDate {
                            Text("Premiered on \(release)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        if let episodesCount = item.episodes?.count {
                            Text("\(episodesCount) episodes")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        if let overview = item.overview {
                            Text(overview)
                                .font(.callout)
                                .padding(.vertical)
                        }
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(settings.disableTranslucent ? .visible : .hidden)
            .background {
                TranslucentBackground(image: item.seasonPosterUrl, useLighterMaterial: true)
            }
            .scrollBounceBehavior(.basedOnSize)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    RoundedCloseButton {
                        selectedSeasonDetails = nil
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    if let url = URL(string: "https://www.themoviedb.org/tv/\(showID)/season/\(item.seasonNumber)") {
                        ShareLink(item: url) {
                            Image(systemName: "square.and.arrow.up")
                                .imageScale(.medium)
                                .accessibilityLabel("Share")
                                .fontDesign(.rounded)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                        }
                        .buttonStyle(.borderedProminent)
                        .contentShape(Circle())
                        .clipShape(Circle())
                        .buttonBorderShape(.circle)
                        .shadow(radius: 2.5)
                    }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(32)
    }
}
