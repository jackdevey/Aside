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
        .formStyle(.grouped)
        .frame(width: 400, height: 200)
    }
}
