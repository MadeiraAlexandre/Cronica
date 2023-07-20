//
//  CustomListView.swift
//  CronicaWatch Watch App
//
//  Created by Alexandre Madeira on 22/04/23.
//

import SwiftUI

struct CustomListView: View {
    @Binding var list: CustomList?
    @State private var showPopup = false
    @State private var popupType: ActionPopupItems?
    var body: some View {
        if let list {
            List {
                Section {
                    if list.itemsArray.isEmpty {
                        EmptyListView()
                    } else {
                        ForEach(list.itemsArray) { item in
                            WatchlistItemRow(content: item, showPopup: $showPopup, popupType: $popupType)
                        }
                    }
                } header: {
                    Text(list.itemTitle)
                        .lineLimit(1)
                }
            }
        } else {
            EmptyListView()
        }
    }
}
