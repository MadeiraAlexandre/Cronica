//
//  Person-Extensions.swift
//  Story (iOS)
//
//  Created by Alexandre Madeira on 24/03/22.
//

import Foundation

extension Person {
    var isAdult: Bool {
        adult ?? true
    }
    var personImage: URL? {
        return NetworkService.urlBuilder(size: .medium, path: profilePath)
    }
    var personBiography: String {
        if let biography = biography {
            if biography.isEmpty {
                return "No information available"
            } else {
               return biography
            }
        }
        return "No information available"
    }
    var personRole: String? {
        job ?? character
    }
    var itemURL: URL {
        return URL(string: "https://www.themoviedb.org/person/\(id)")!
    }
}
