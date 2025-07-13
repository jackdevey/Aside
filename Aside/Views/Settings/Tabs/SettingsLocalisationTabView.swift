//
//  LocalisationTabView.swift
//  Aside
//
//  Created by Jack Devey on 06/07/2025.
//

import SwiftUI

struct SettingsLocalisationTabView: View {
    
    @StateObject private var settings = SettingsManager.shared
    
    var body: some View {
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
            Section(header: Text("Language")) {
                HStack {
                    Text("Identifier")
                    Spacer()
                    Text(Locale.current.identifier)
                        .monospaced()
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Localisation")
    }
    
    var label: some View {
        Label("Localisation", systemImage: "globe")
    }
}
