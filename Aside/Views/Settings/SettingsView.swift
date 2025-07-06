//
//  SettingsView.swift
//  Aside
//
//  Created by Jack Devey on 22/06/2025.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
        
    var macOS: some View {
        TabView {
            // Localisation
            SettingsLocalisationTabView()
            .tabItem {
                SettingsLocalisationTabView().label
            }
            // App Data
            SettingsAppDataTabView()
            .tabItem {
                SettingsAppDataTabView().label
            }
            // About
            SettingsAboutTabView()
            .tabItem {
                SettingsAboutTabView().label
            }
        }
        .formStyle(.grouped)
        .frame(width: 400, height: 200)
    }
    
    var iOS: some View {
        NavigationView {
            List {
                NavigationLink(destination: SettingsLocalisationTabView()) {
                    SettingsLocalisationTabView().label
                }
                NavigationLink(destination: SettingsAppDataTabView()) {
                    SettingsAppDataTabView().label
                }
                NavigationLink(destination: SettingsAboutTabView()) {
                    SettingsAboutTabView().label
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
    }
    
    var body: some View {
        #if os(macOS)
        macOS
        #else
        iOS
        #endif
    }
    
}

