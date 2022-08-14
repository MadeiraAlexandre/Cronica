//
//  NetworkError.swift
//  Story (iOS)
//
//  Created by Alexandre Madeira on 09/05/22.
//

import Foundation

enum NetworkError: Error, CustomNSError {
    case invalidResponse, invalidRequest, invalidEndpoint, decodingError
    case invalidApi, internalError, maintenanceApi
    
    var errorMessage: String {
        switch self {
        case .invalidResponse:
            return NSLocalizedString("Invalid Response", comment: "")
        case .invalidRequest:
            return NSLocalizedString("Invalid Request", comment: "")
        case .invalidEndpoint:
            return NSLocalizedString("Invalid Endpoint", comment: "")
        case .decodingError:
            return NSLocalizedString("Error reading this title", comment: "")
        case .invalidApi:
            return NSLocalizedString("Invalid API key: You must be granted a valid key.", comment: "")
        case .internalError:
            return NSLocalizedString("Internal error: Something went wrong, contact TMDB.", comment: "")
        case .maintenanceApi:
            return NSLocalizedString("The API is undergoing maintenance. Try again later.", comment: "")
        }
    }
}
