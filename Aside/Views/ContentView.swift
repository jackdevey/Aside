//
//  ContentView.swift
//  Aside
//
//  Created by Jack Devey on 01/08/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
        
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)])
    var goals: FetchedResults<Goal>
    
    @State var wantsNewGoal = false
    @State var name = ""
    
    @State var search: String = ""
        
    var body: some View {
        NavigationView {
            List {
                Section("Goals") {
                    ForEach(goals) { goal in
                        GoalView(goal: goal, deleteFunc: deleteGoal)
                    }
                }
            }
            .frame(minWidth: 190)
            .listStyle(.sidebar)
            .toolbar {
                // New goal icon
                ToolbarItem(placement: .primaryAction) {
                    Button(action: toggleSidebar) {
                        Label("Toggle sidebar", systemImage: "sidebar.leading")
                    }
                }
                // New goal icon
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { wantsNewGoal = true }) {
                        Label("New goal", systemImage: "plus")
                    }
                }
            }
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
            NewGoalSheet(isPresented: $wantsNewGoal, onFinish: { name, target, icon in
                Task { await newGoal(name: name, target: target, sfIconName: icon) }
            })
        }
    }
    
    private func newGoal(name: String, target: Float, sfIconName: String) async {
        await viewContext.perform({
            let goal = Goal(context: viewContext)
            goal.id = UUID()
            goal.name = name
            goal.sfIconName = sfIconName
            goal.target = target
            goal.saved = 0
            goal.currency = "£"
            
        })
        try? PersistanceController.shared.saveContext()
    }
    
    private func deleteGoal(goal: Goal) {
        Task {
            await viewContext.perform { viewContext.delete(goal) }
            try? PersistanceController.shared.saveContext()
        }
    }
    
    private func toggleSidebar() { // 2
        #if os(iOS)
        #else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }
}
