//
//  SupportEmail.swift
//  Story (iOS)
//
//  Created by Alexandre Madeira on 24/03/22.
//

import UIKit
import SwiftUI

struct SupportEmail {
    let toAddress: String = "contact@alexandremadeira.dev"
    let subject: String = "Support Email (Cronica App)"
    let messageHeader: String = "Please describe your issue below"
    var body: String {"""
        iOS: \(UIDevice.current.systemVersion)
        Device Model: \(UIDevice.current.modelName)
        App Version: \(Bundle.main.appVersion)
        App Build: \(Bundle.main.appBuild)
        \(messageHeader)
        --------------------------------------
    """
    }
    
    func send(openURL: OpenURLAction) {
        let urlString = "mailto:\(toAddress)?subject=\(subject.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
        guard let url = URL(string: urlString) else { return }
        openURL(url) { accepted in
            if !accepted {
                print("""
                This device does not support email
                \(body)
                """
                )
            }
        }
    }
}
