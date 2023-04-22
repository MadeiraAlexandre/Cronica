//
//  WatchlistSelectorView.swift
//  CronicaWatch Watch App
//
//  Created by Alexandre Madeira on 21/04/23.
//

import SwiftUI

struct WatchlistSelectorView: View {
    @Binding var showView: Bool
    @Binding var selectedList: DefaultListTypes?
    @Binding var selectedCustomList: CustomList?
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CustomList.title, ascending: true)],
        animation: .default)
    private var lists: FetchedResults<CustomList>
    @State private var item: WatchlistItem?
    var body: some View {
        NavigationStack {
            Form {
                List {
                    Section {
                        ForEach(DefaultListTypes.allCases) { list in
                            Button {
                                selectedCustomList = nil
                                selectedList = list
                                showView = false
                            } label: {
                                HStack {
                                    if selectedList == list {
                                        Image(systemName: "checkmark.circle.fill")
                                    }
                                    Text(list.title)
                                }
                            }
                        }
                    } header: {
                        Text("defaultWatchlistSmartFilters")
                    }
                    
                    Section {
                        ForEach(lists) { list in
                            Button {
                                selectedList = nil
                                selectedCustomList = list
                                showView = false
                            } label: {
                                HStack {
                                    if selectedCustomList == list {
                                        Image(systemName: "checkmark.circle.fill")
                                    }
                                    Text(list.itemTitle)
                                }
                            }
                        }
                    } header: {
                        Text("yourLists")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { showView.toggle() }
                }
            }
        }
    }
}