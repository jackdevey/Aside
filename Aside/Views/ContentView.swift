//
//  ContentView.swift
//  Aside
//
//  Created by Jack Devey on 01/08/2022.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var settings = SettingsManager.shared
    
    @Query()
    var goals: [Goal]
    
    @State var wantsNewGoal = false
    @State var name = ""
    
    @State var search: String = ""
    
    @State var selection: Goal?
        
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                if goals.isEmpty {
                    // Show content not available
                    #if os(macOS)
                    ContentUnavailableView("No goals",
                        systemImage: "target",
                        description: Text("Use the ") + Text(Image(systemName: "plus")) + Text(" button")
                    )
                    .symbolVariant(.slash)
                    #else
                    ContentUnavailableView("No goals",
                        systemImage: "target",
                        description: Text("Tap the ") + Text(Image(systemName: "plus")) + Text(" icon to create a new goal")
                    )
                    .symbolVariant(.slash)
                    #endif
                } else {
                    // List goals
                    ForEach(goals){ goal in
                        NavigationLink(value: goal) {
                            #if os(macOS)
                            Label(goal.name, systemImage: goal.sfIcon)
                            #else
                            HStack(spacing: 20) {
                                Label(goal.name, systemImage: goal.sfIcon)
                                Spacer()
                                goal.progressCircle()
                                    .padding(.trailing, 10)
                            }
                            #endif
                        }
                    }
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 220, max: 240)
            .navigationTitle("Goals")
            .toolbar {
                // New goal icon
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { wantsNewGoal = true }) {
                        Label("New goal", systemImage: "plus")
                    }
                }
            }
        } detail: {
            // Show the GoalView for the goal
            if let goal = selection {
                GoalView(goal: goal, deleteFunc: deleteGoal)
            } else {
                VStack {
                    Image("icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 50)
                        .foregroundColor(.accentColor)
                        .padding()
                    Group {
                        Text("Welcome to aside")
                            .font(.title)
                            .bold()
                        Text("The best way to manage your money!")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Button("Create a new goal") {
                            wantsNewGoal = true
                        }
                        Text("or select one from the side")
                    }
                }
            }
        }
        // New goal sheet
        .sheet(isPresented: $wantsNewGoal) {
            AddEditGoalSheet()
            #if os(iOS)
                .presentationDetents([.medium, .large])
            #endif
        }
    }
    
    private func deleteGoal(goal: Goal) {
        modelContext.delete(goal)
        try? modelContext.save()
        selection = nil
    }
}
