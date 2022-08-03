//
//  AsideApp.swift
//  Aside
//
//  Created by Jack Devey on 01/08/2022.
//

import SwiftUI

@main
struct AsideApp: App {
    let persistenceController = PersistanceController.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }

        
        // Commands
        .commands {
            CommandGroup(replacing: .newItem) {
                Button("New goal") {
                    
                }.keyboardShortcut("n", modifiers: [.command])
            }
        }
        
        .windowToolbarStyle(.unified)
        .windowStyle(.titleBar)
    }
}

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
