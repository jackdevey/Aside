//
//  SettingsView.swift
//  Aside
//
//  Created by Jack Devey on 22/06/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var settings = SettingsManager.shared
    
    var body: some View {
        TabView {
            // Localisation
            Form {
                Section(header: Text("Currency")) {
                    TextField("Code", text: $settings.currencyCode)
                    HStack {
                        Text("Example")
                        Spacer()
                        Text(3.50, format: .currency(code: settings.currencyCode)) // Tree Fiddy
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .tabItem {
                Label("Localisation", systemImage: "globe")
            }
            // App Data
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
            .tabItem {
                Label("App Data", systemImage: "tray.full")
            }
            // About
            Form {
                Section(
                    header: Text("About App")
                ) {
                    HStack {
                        AppIconView()
                            .frame(width: 24, height: 24)
                        Text("Aside for \(software)")
                        Spacer()
                        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                            Text("v\(version)")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .tabItem {
                Label("About", systemImage: "info.circle")
            }
        }
        .formStyle(.grouped)
        .frame(width: 400, height: 200)
    }
    
    var software: String {
        #if os(iOS)
        "iOS"
        #elseif os(macOS)
        "macOS"
        #else
        "Unknown OS"
        #endif
    }
    
}

