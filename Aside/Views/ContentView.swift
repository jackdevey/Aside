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
    
    @Query()
    var goals: [Goal]
    
    @State var wantsNewGoal = false
    @State var name = ""
    
    @State var search: String = ""
        
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(goals){ goal in
                    NavigationLink {
                        GoalView(goal: goal, deleteFunc: deleteGoal)
                    } label: {
                        Label(goal.name, systemImage: goal.sfIcon)
                    }
                }
            }
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
            VStack {
                Image(systemName: "sterlingsign.square")
                    .resizable()
                    .frame(width: 50, height: 50)
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
        // New goal sheet
        .sheet(isPresented: $wantsNewGoal) {
            AddEditGoalSheet()
            #if os(iOS)
                .presentationDetents([.medium, .large])
            #endif
        }
    }
    
    private func deleteGoal(goal: Goal) {
        Task {
            modelContext.delete(goal)
            try? modelContext.save()
        }
    }
}
