//
//  SettingsView.swift
//  CronicaTV
//
//  Created by Alexandre Madeira on 28/10/22.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("disableTelemetry") private var disableTelemetry = false
    @State private var updatingItems = false
    var body: some View {
        Form {
            // MARK: Update Section
            Section {
                Button(action: {
                    updateItems()
                }, label: {
                    if updatingItems {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    } else {
                        Text("Update Items")
                    }
                })
            } header: {
                Label("Sync", systemImage: "arrow.2.circlepath")
            } footer: {
                Text("'Update Items' will update your items with new information available on TMDb, if available.")
                    .padding(.bottom)
            }
            
            Section {
                Toggle("Disable Telemetry", isOn: $disableTelemetry)
            } header: {
                Label("Privacy", systemImage: "hand.raised.fingers.spread")
            } footer: {
                Text("privacyFooterTV")
                    .padding(.bottom)
            }
            
            HStack {
                Spacer()
                Text("Made in Brazil 🇧🇷")
                Spacer()
            }
        }
        .navigationTitle("Settings")
    }
    
    private func updateItems() {
        Task {
            let background = BackgroundManager()
            withAnimation {
                self.updatingItems.toggle()
            }
            await background.handleAppRefreshContent()
            withAnimation {
                self.updatingItems.toggle()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
