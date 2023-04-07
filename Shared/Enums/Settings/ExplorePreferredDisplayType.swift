//
//  ExplorePreferredDisplayType.swift
//  Story (iOS)
//
//  Created by Alexandre Madeira on 07/04/23.
//

import Foundation

enum ExplorePreferredDisplayType: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case card, poster
    
    var title: String {
        switch self {
        case .card: return NSLocalizedString("explorePreferredDisplayTypeCard", comment: "")
        case .poster: return NSLocalizedString("explorePreferredDisplayTypePoster", comment: "")
        }
    }
}
