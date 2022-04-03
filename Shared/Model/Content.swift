//
//  Content.swift
//  Story
//
//  Created by Alexandre Madeira on 17/02/22.
//

import Foundation
import SwiftUI

struct Content: Identifiable, Decodable {
    let id: Int
    let title, name, overview: String?
    let posterPath, backdropPath, profilePath: String?
    let releaseDate, status: String?
    let runtime, numberOfEpisodes, numberOfSeasons: Int?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let seasons: [Season]?
    let genres: [Genre]?
    let credits: Credits?
    let recommendations: ContentResponse?
    let releaseDates: ReleaseDates?
    let mediaType: String?
}
struct Season: Decodable, Identifiable {
    let id: Int
    let airDate: String?
    let episodeCount: Int?
    let episodes: [Episode]?
    let name, overview, posterPath: String?
    let seasonNumber: Int
}
struct ReleaseDates: Decodable {
    let results: [ReleaseDatesResult]
}
struct ReleaseDatesResult: Decodable {
    let iso31661: String?
    let releaseDates: [ReleaseDate]?
}
struct ReleaseDate: Decodable {
    let certification, iso6391, releaseDate: String?
    let type: Int?
}
struct ProductionCompany: Decodable {
    let id: Int
    let logoPath: String?
    let name: String
}
struct ProductionCountry: Decodable {
    let name: String?
}
struct Genre: Decodable, Identifiable {
    let id: Int
    let name: String?
}
struct Episode: Identifiable, Decodable {
    let id: Int
    let airDate: String
    let episodeNumber: Int
    let crew, guestStars: [Person]?
    let name, overview, stillPath: String?
    let seasonNumber: Int
}
struct ContentResponse: Identifiable, Decodable {
    let id: String?
    let results: [Content]
}
struct ContentSection: Identifiable {
    var id = UUID()
    let results: [Content]
    let endpoint: Endpoints
    var title: String {
        endpoint.title
    }
    var subtitle: String {
        endpoint.subtitle
    }
    var image: String {
        endpoint.image
    }
    var style: StyleType {
        switch endpoint {
        case .upcoming:
            return StyleType.poster
        case .nowPlaying:
            return StyleType.poster
        case .onTheAir:
            return StyleType.poster
        }
    }
}
