//
//  ShareButtonView.swift
//  Story (iOS)
//
//  Created by Alexandre Madeira on 09/07/22.
//

import SwiftUI

// Only for iOS 15.
struct ShareButtonView: View {
    var hideTitle: Bool = false
    @State var shareLink: [Any] = []
    @State private var showShare: Bool = false
    var body: some View {
        Button(action: {
            HapticManager.shared.softHaptic()
            if !shareLink.isEmpty {
                showShare.toggle()
            }
        }, label: {
            if hideTitle {
                Image(systemName: "square.and.arrow.up")
            } else {
                Label("Share", systemImage: "square.and.arrow.up")
            }
        })
        .sheet(isPresented: $showShare) {
            ActivityViewController(itemsToShare: $shareLink)
        }
    }
}

struct ShareButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ShareButtonView()
    }
}
