//
//  TitleView.swift
//  Story (iOS)
//
//  Created by Alexandre Madeira on 03/04/22.
//

import SwiftUI

struct TitleView: View {
    let title: String
    let subtitle: String
    let image: String
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(NSLocalizedString(title, comment: ""))
                        .font(.headline)
                        .padding([.top, .horizontal])
                    Spacer()
                }
                HStack {
                    Text(NSLocalizedString(subtitle, comment: ""))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    Spacer()
                }
            }
            Spacer()
            Image(systemName: image)
                .foregroundColor(.secondary)
                .padding()
                .accessibilityHidden(true)
        }
        .unredacted()
        .accessibilityElement(children: .combine)
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView(title: "Coming Soon", subtitle: "From Watchlist", image: "rectangle.stack")
    }
}
