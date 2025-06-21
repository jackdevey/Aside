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
    
    @StateObject private var settings = SettingsManager.shared
    
    @State private var deleteAlert = false
    @State private var editSheet = false
    @State private var newTransactionSheet = false
    
    var deleteFunc: (Goal) -> ()
    
    @State var transactionSelection: FiscalTransaction.ID?
    @State private var transactionSorting = [KeyPathComparator(\FiscalTransaction.date, order: .reverse)]
        
    var dateFormatter: DateFormatter = DateFormatter()
    
    var body: some View {
        // Transaction log table
        Table(goal.transactions, selection: $transactionSelection) {
            // Amount column
            TableColumn("Amount") { transaction in
                Text(String(format: "%@%.2f", transaction.amount >= 0 ? "+" : "-", abs(transaction.amount)))
                    .monospacedDigit()
            }
            // Name column
            TableColumn("Name", value: \.name)
            // Category column
            TableColumn("Category") { transaction in
                transaction.category.labelView()
            }
            // Date column
            TableColumn("Date") { transaction in
                Text(transaction.date, format: .dateTime)
            }
        }
        // Set title & subtitle
        .navigationTitle(goal.name)
        .navigationSubtitle(
            """
            \(String(format: "%.0f", goal.percentage))% \
            - \(goal.target - goal.saved, format: .currency(code: settings.currencyCode)) left
            """
        )
        // Add search through transactions
        .toolbar {
            ToolbarItem(placement: .navigation) {
                HStack(spacing: 10) {
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
                    Image(systemName: goal.sfIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.secondary)
                }
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
        //.searchable(text: $search, prompt: "Search transactions")
        // Goal delete alert
        .alert(isPresented: $deleteAlert) {
            Alert(
                title: Text("Are you sure you want to delete this goal?"),
                message: Text("You cannot undo this later, '\(goal.name)' will be lost forever!"),
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
            AddEditGoalSheet(goalToEdit: goal)
        }
        // New transaction sheet
        .sheet(isPresented: $newTransactionSheet) {
            AddEditTransactionSheet(goal: goal)
        }
    }
}
