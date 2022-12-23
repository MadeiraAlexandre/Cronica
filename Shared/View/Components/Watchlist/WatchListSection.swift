//
//  WatchListSection.swift
//  Story (iOS)
//
//  Created by Alexandre Madeira on 24/04/22.
//

import SwiftUI

struct WatchListSection: View {
    let items: [WatchlistItem]
    var title: String
    private let context = PersistenceController.shared
    @State private var multiSelection = Set<String>()
    @State private var sortOrder = [KeyPathComparator(\WatchlistItem.itemTitle)]
    var body: some View {
        if !items.isEmpty {
#if os(macOS)
            table
#else
            Section {
                ForEach(items, id: \.notificationID) { item in
                    WatchlistItemRow(content: item)
                        .draggable(item)
                }
                .onDelete(perform: delete)
            } header: {
                Text(NSLocalizedString(title, comment: ""))
            } footer: {
                Text("\(items.count) items")
                    .padding(.bottom)
            }
#endif
        } else {
            Text("This list is empty.")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding()
        }
    }
    
    private var table: some View {
        Table(items, sortOrder: $sortOrder) {
            TableColumn("Title") { item in
                WatchlistItemRow(content: item)
                    .buttonStyle(.plain)
            }
            TableColumn("Media", value: \.itemMedia.title)
            TableColumn("Genre", value: \.itemGenre)
        }
        .tableStyle(.inset)
    }
    
    private var list: some View {
        List(selection: $multiSelection) {
            Section {
                ForEach(items, id: \.notificationID) { item in
                    WatchlistItemRow(content: item)
                        .draggable(item)
                }
                .onDelete(perform: delete)
            } header: {
                Text(NSLocalizedString(title, comment: ""))
            } footer: {
                Text("\(items.count) items")
                    .padding(.bottom)
            }
        }
        .dropDestination(for: ItemContent.self) { items, _  in
            fetchDroppedItems(for: items)
            return true
        }
    }
    
    private func fetchDroppedItems(for items: [ItemContent]) {
        for item in items {
            Task {
                let result = try? await NetworkService.shared.fetchItem(id: item.id, type: item.itemContentMedia)
                if let result {
                    PersistenceController.shared.save(result)
                }
            }
        }
    }
    
    private func delete(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(context.delete)
        }
    }
    
    private var deleteAllButton: some View {
        Button(role: .destructive, action: {
            withAnimation {
                PersistenceController.shared.delete(items: multiSelection)
            }
        }, label: {
            Label("Remove Selected", systemImage: "trash")
        })
    }
    
    private var updatePinButton: some View {
        Button {
            PersistenceController.shared.updatePin(items: multiSelection)
        } label: {
            Label("Pin Items", systemImage: "pin.fill")
        }
    }
    
    private var updateWatchButton: some View {
        Button(action: {
            PersistenceController.shared.updateMarkAs(items: multiSelection)
        }, label: {
            if title != "Watched" {
                Label("Mark selected as watched", systemImage: "checkmark.circle")
            } else {
                Label("Mark selected as unwatched", systemImage: "minus.circle")
            }
        })
    }
}
