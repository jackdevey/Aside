//
//  GoalView.swift
//  Aside
//
//  Created by Jack Devey on 01/08/2022.
//

import SwiftUI

struct GoalView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var goal: Goal
    @State var search: String = ""
    
    @State private var deleteAlert = false
    @State private var editSheet = false
    @State private var newTransactionSheet = false
    
    var deleteFunc: (Goal) -> ()
    
    @State var transactionSelection: Transaction.ID?
    @State private var transactionSorting = [KeyPathComparator(\Transaction.date, order: .reverse)]
        
    var dateFormatter: DateFormatter = DateFormatter()
    
    var body: some View {
        NavigationLink {
            // Transaction log table
            Table(goal.transactionLog, selection: $transactionSelection) {
                TableColumn("Name", value: \.wName)
                TableColumn("Ammount", value: \.ammountString)
                TableColumn("Date", value: \.dateString)
            }
            // Set title & subtitle
            .navigationTitle(goal.name ?? "Unkown")
            .navigationSubtitle("\(goal.percentageString) - £\(goal.remainingString) left")
            // Add icons to toolbar
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    ZStack {
                        Circle()
                            .stroke(.tertiary, lineWidth: 3)
                            .frame(width: 18, height: 18)
                        Circle()
                            .trim(from: 0.0, to: Double(goal.percentage))
                            .stroke(Color.accentColor, lineWidth: 3)
                            .frame(width: 18, height: 18)
                            .rotationEffect(Angle(degrees: -90))
                    }
                }
                // Goal icon
                ToolbarItem(placement: .navigation) {
                    Image(systemName: goal.sfIconName ?? "")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.secondary)
                }
                // Add transaction button
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { newTransactionSheet = true }) {
                        Label("New transaction", systemImage: "text.badge.plus")
                    }
                }
                // Edit goal button
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { editSheet = true }) {
                        Label("Edit", systemImage: "square.and.pencil")
                    }
                }
                // Delete goal button
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { deleteAlert = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            // Add search through transactions
            //.searchable(text: $search, prompt: "Search transactions")
        }
        
        // Label in app sidebar
        label: {
            Label(goal.name ?? "Unkown", systemImage: goal.sfIconName ?? "")
        }
        // Goal delete alert
        .alert(isPresented: $deleteAlert) {
            Alert(
                title: Text("Are you sure you want to delete this goal?"),
                message: Text("You cannot undo this later, '\(goal.name ?? "Unknown")' will be lost forever!"),
                primaryButton: .default(
                    Text("Delete"),
                    action: { deleteFunc(goal) }
                ),
                secondaryButton: .cancel(
                    Text("Cancel"),
                    action: {}
                )
            )
        }
        // Edit sheet
        .sheet(isPresented: $editSheet) {
            EditGoalSheet(
                isPresented: $editSheet,
                onFinish: { name, target, icon in
                    // Update goal
                    goal.name = name
                    goal.target = target
                    goal.sfIconName = icon
                    try? viewContext.save()
                },
                name: goal.name ?? "Unknown",
                target: goal.target,
                icon: goal.sfIconName ?? "square"
            )
        }
        // New transaction sheet
        .sheet(isPresented: $newTransactionSheet) {
            NewTransactionSheet(onClose: {
                newTransactionSheet = false
            }, onCreate: { name, ammount, date, direction in
                let transaction = Transaction(context: viewContext)
                transaction.id = UUID()
                transaction.name = name
                transaction.ammount = ammount
                transaction.date = date
                transaction.direction = direction
                goal.addToTransactions(transaction)
                
                try? viewContext.save()
            })
        }
    }
}
