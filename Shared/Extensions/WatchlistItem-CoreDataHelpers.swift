//
//  WatchlistItem-CoreDataHelpers.swift
//  Story
//
//  Created by Alexandre Madeira on 15/02/22.
//

import Foundation
import CoreData

extension WatchlistItem {
    var itemTitle: String {
        title ?? NSLocalizedString("No title available",
                                   comment: "Title couldn't be found.")
    }
    var itemId: Int {
        Int(id)
    }
    var itemMedia: MediaType {
        switch contentType {
        case 0: return .movie
        case 1: return .tvShow
        case 2: return .person
        default: return .movie
        }
    }
    var itemSchedule: ContentSchedule {
        switch schedule {
        case 0: return .soon
        case 1: return .released
        case 2: return .production
        case 3: return .cancelled
        default: return .unknown
        }
    }
    var itemLink: URL {
        return URL(string: "https://www.themoviedb.org/\(itemMedia.rawValue)/\(itemId)")!
    }
    static var example: WatchlistItem {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        let item = WatchlistItem(context: viewContext)
        item.title = Content.previewContent.itemTitle
        item.id = Int64(Content.previewContent.id)
        item.image = Content.previewContent.cardImageMedium
        item.contentType = 0
        item.notify = false
        return item
    }
}