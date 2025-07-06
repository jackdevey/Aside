//
//  AppDataTabView.swift
//  Aside
//
//  Created by Jack Devey on 06/07/2025.
//

import SwiftUI

struct SettingsAppDataTabView: View {
    
    var body: some View {
        Form {
            Section(
                header: Text("iCloud Sync")
            ) {
                HStack {
                    Text("Syncing data to iCloud")
                    Spacer()
                    Text("Enabled")
                        .foregroundStyle(.secondary)
                }
            }
            Section(header: Text("Manage App Data")) {
                HStack {
                    Text("Export app data as JSON")
                    Spacer()
                    ExportAppDataButton()
                }
                Text("All app data can be deleted in the iCloud Storage settings on your device.")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("App Data")
    }
    
    var label: some View {
        Label("App Data", systemImage: "tray.full")
    }
    
}
