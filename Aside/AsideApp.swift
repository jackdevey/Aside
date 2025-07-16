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
    
    // Create the model container once
    let modelContainer = try! ModelContainer(for: FiscalTransaction.self, Goal.self)
        
    var body: some Scene {
        WindowGroup {
            ContentView()
            #if os(macOS)
                .frame(minWidth: 1000, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
            #endif
        }
        .modelContainer(modelContainer)
        
        #if os(macOS)
        Settings {
            SettingsView()
                .modelContainer(modelContainer)
        }
        #endif
    }
}
