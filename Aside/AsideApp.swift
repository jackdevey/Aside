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
    
    @State var showNewGoalSheet = false
    
    
    var df: DataFunctions = DataFunctions()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
            
            // New goal sheet for new goal command
            .sheet(isPresented: $showNewGoalSheet) {
                NewGoalSheet(isPresented: $showNewGoalSheet, onFinish: { name, target, icon in
                    Task { await df.newGoal(name: name, target: target, sfIconName: icon) }
                })
            }
        }
        // Add custom commands to menu bar
        .commands {
            CommandGroup(replacing: .newItem) {
                // New goal command (command + n)
                Button("New goal") {
                    showNewGoalSheet = true
                }.keyboardShortcut("n", modifiers: [.command])
            }
        }
    }
}

extension Binding {
     func toUnwrapped<T>(defaultValue: T) -> Binding<T> where Value == Optional<T>  {
        Binding<T>(get: { self.wrappedValue ?? defaultValue }, set: { self.wrappedValue = $0 })
    }
}
