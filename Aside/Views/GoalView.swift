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
    
    @State private var transactionToEdit: FiscalTransaction? = nil
    
    var deleteFunc: (Goal) -> ()
    
    @State var transactionSelection: FiscalTransaction.ID?
    @State private var transactionSorting = [KeyPathComparator(\FiscalTransaction.date, order: .reverse)]
        
    var dateFormatter: DateFormatter = DateFormatter()
    
    var table: some View {
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
    }
    
    var listWithHeader: some View {
        List {
            VStack(alignment: .leading) {
                // Goal name & icon
                HStack {
                    Image(systemName: goal.sfIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 24)
                        .foregroundStyle(.accent)
                    Text(goal.name)
                        .font(.title2)
                        .bold()
                    Spacer()
                    // Show menu
                    Menu {
                        Button(action: { editSheet = true }) {
                            Label("Edit", systemImage: "square.and.pencil")
                        }
                        Button(action: { deleteAlert = true }) {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Label("Options", systemImage: "ellipsis.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .labelStyle(.iconOnly)
                            .font(.title2)
                    }
                }
                // Progress view
                ProgressView(value: goal.saved, total: goal.target) {
                    Text("\(goal.target - goal.saved, format: .currency(code: settings.currencyCode)) left")
                    .foregroundStyle(.secondary)
                }
                .padding(.top, 5)
            }
            .padding([.top, .bottom], 5)
            Section {
                if goal.transactions.isEmpty {
                    ContentUnavailableView("No transactions",
                        systemImage: "text.insert",
                        description: Text("Tap the ") + Text(Image(systemName: "text.badge.plus")) + Text(" icon to create a new transaction for this goal"))
                } else {
                    ForEach(goal.transactions) { transaction in
                        HStack {
                            // Show only category icon
                            transaction.category.labelView()
                                .labelStyle(.iconOnly)
                                .font(.system(size: 24))
                                .foregroundStyle(.accent)
                            // Amount
                            Text(String(format: "%@%.2f", transaction.amount >= 0 ? "+" : "-", abs(transaction.amount)))
                                .monospacedDigit()
                            Spacer()
                            VStack(alignment: .trailing) {
                                // Name
                                Text(transaction.name)
                                // Date
                                Text(transaction.date, format: .dateTime)
                                    .foregroundStyle(.secondary)
                                    .font(.caption)
                            }
                        }
                        // Add edit button on swipe
                        .swipeActions {
                            Button {
                                transactionToEdit = transaction
                            } label: {
                                Label("Edit Transaction", systemImage: "pencil")
                            }
                        }
                    }
                }
            }
        }
    }
    
    var body: some View {
        Group {
            #if os(macOS)
            table
            #else
            listWithHeader
            #endif
        }
        // Set title & subtitle
        .navigationTitle(goal.name)
        #if os(macOS)
        .navigationSubtitle("\(goal.target - goal.saved, format: .currency(code: settings.currencyCode)) left")
        #elseif os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        // Add search through transactions
        .toolbar {
            #if os(macOS)
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
            #endif
            // Add transaction button
            ToolbarItem(placement: .primaryAction) {
                Button(action: { newTransactionSheet = true }) {
                    Label("New transaction", systemImage: "text.badge.plus")
                }
            }
            #if os(macOS)
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
            #endif
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
            #if os(iOS)
                .presentationDetents([.medium, .large])
            #endif
        }
        // New transaction sheet
        .sheet(isPresented: $newTransactionSheet) {
            AddEditTransactionSheet(goal: goal)
            #if os(iOS)
                .presentationDetents([.medium, .large])
            #endif
        }
        // Edit transaction sheet
        .sheet(item: $transactionToEdit) { transaction in
            AddEditTransactionSheet(goal: goal, transactionToEdit: transaction)
            #if os(iOS)
                .presentationDetents([.medium, .large])
            #endif
        }
    }
}
