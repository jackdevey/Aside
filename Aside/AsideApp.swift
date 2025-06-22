//
//  AsideApp.swift
//  Aside
//
//  Created by Jack Devey on 01/08/2022.
//

import SwiftUI
import SwiftData

@main
struct AsideApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            #if os(macOS)
                .frame(minWidth: 800, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
            #endif
        }
        .modelContainer(for: [FiscalTransaction.self, Goal.self])
        
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
