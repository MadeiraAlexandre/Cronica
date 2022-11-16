//
//  Utilities.swift
//  Story
//
//  Created by Alexandre Madeira on 15/01/22.
//

import Foundation

class Utilities {
    static let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y,MM,dd"
        return formatter
    }()
    static let dateString: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    static let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    static let shortDurationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    static let userLang: String = {
        let locale = Locale.current
        guard let langCode = locale.language.languageCode?.identifier,
              let regionCode = locale.language.region?.identifier else {
            return "en-US"
        }
        return "\(langCode)-\(regionCode)"
    }()
    static let userRegion: String = {
        guard let regionCode = Locale.current.language.region?.identifier else {
            return "US"
        }
        return regionCode
    }()
    private static var releaseDateFormatter: ISO8601DateFormatter {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withFullDate
        return formatter
    }
    static func getReleaseDateFormatted(results: [ReleaseDatesResult]) -> String? {
        for result in results {
            if result.iso31661 == Utilities.userRegion {
                if result.releaseDates != nil {
                    for date in result.releaseDates! {
                        if date.type != nil && date.type == 3 {
                            let release = releaseDateFormatter.date(from: date.releaseDate!)!
                            return dateString.string(from: release)
                        }
                        if date.type != nil && date.type == 4 {
                            let release = releaseDateFormatter.date(from: date.releaseDate!)!
                            return dateString.string(from: release)
                        }
                        if date.type != nil && date.type == 6 {
                            let release = releaseDateFormatter.date(from: date.releaseDate!)!
                            return dateString.string(from: release)
                        }
                    }
                }
            }
            if result.iso31661 == "US" {
                if let dates = result.releaseDates {
                    for date in dates {
                        if date.type != nil && date.type == 3 {
                            let release = releaseDateFormatter.date(from: date.releaseDate!)!
                            return dateString.string(from: release)
                        }
                        if date.type != nil && date.type == 4 {
                            let release = releaseDateFormatter.date(from: date.releaseDate!)!
                            return dateString.string(from: release)
                        }
                        if date.type != nil && date.type == 6 {
                            let release = releaseDateFormatter.date(from: date.releaseDate!)!
                            return dateString.string(from: release)
                        }
                    }
                }
            }
        }
        return nil
    }
}
