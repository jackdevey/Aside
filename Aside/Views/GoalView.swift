//
//  GoalView.swift
//  Aside
//
//  Created by Jack Devey on 01/08/2022.
//

import SwiftUI
import ConfettiSwiftUI

struct GoalView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    var goal: Goal
    @Binding var selection: Goal?
    
    @State var search: String = ""
    
    @StateObject private var settings = SettingsManager.shared
    
    @State private var deleteAlert = false
    @State private var editSheet = false
    
    @State private var newTransactionSheet = false
    
    @State private var transactionToEdit: FiscalTransaction? = nil
        
    @State var transactionSelection: FiscalTransaction.ID?
    @State private var transactionSorting = [KeyPathComparator(\FiscalTransaction.date, order: .reverse)]
        
    var dateFormatter: DateFormatter = DateFormatter()
    
    @State var transactionSortOption: FiscalTransactionSortOption = .date
    @State var transactionSortOrder: AsideSortOrder = .descending
    
    @State var showInspector: Bool = true
    
    @State private var confettiTrigger: Bool = false
    
    var table: some View {
        Table(goal.transactions.sorted(by: sorter), selection: $transactionSelection) {
            // Amount column
            TableColumn("Amount") { transaction in
                Text(transaction.amount, format: .currency(code: settings.currencyCode))
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
        .inspector(isPresented: $showInspector) {
            List {
                GoalInfoView(goal: goal, deleteAlert: $deleteAlert, editSheet: $editSheet)
            }
        }
    }
    
    var listWithHeader: some View {
        List {
            // Display goal info view first
            GoalInfoView(goal: goal, deleteAlert: $deleteAlert, editSheet: $editSheet)
            // Then transactions list
            Section(header: HStack {
                Text("Transactions")
                    .font(.title3)
                    .bold()
                Spacer()
                transactionSortSelector
            }) {
                if goal.transactions.isEmpty {
                    ContentUnavailableView("No transactions",
                        systemImage: "text.insert",
                        description: Text("Tap the ") + Text(Image(systemName: "text.badge.plus")) + Text(" icon to create a new transaction for this goal"))
                } else {
                    ForEach(goal.transactions.sorted(by: sorter)) { transaction in
                        HStack {
                            // Show only category icon
                            transaction.category.labelView()
                                .labelStyle(.iconOnly)
                                .font(.system(size: 24))
                                .foregroundStyle(.accent)
                            // Amount
                            Text(transaction.amount, format: .currency(code: settings.currencyCode))
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
            .headerProminence(.increased)
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
            // Add transaction button
            ToolbarItem(placement: .primaryAction) {
                Button(action: { newTransactionSheet = true }) {
                    Label("New transaction", systemImage: "text.badge.plus")
                }
            }
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
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Button(action: { editSheet = true }) {
                        Label("Edit", systemImage: "square.and.pencil")
                    }
                    Button(action: { deleteAlert = true }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Label("Options", systemImage: "ellipsis")
                }
            }
            ToolbarItem(placement: .primaryAction) {
                transactionSortSelector
            }
            #endif
        }
        // Add confetti cannon
        .confettiCannon(trigger: $confettiTrigger)
        //.searchable(text: $search, prompt: "Search transactions")
        // Goal delete alert
        .alert(isPresented: $deleteAlert) {
            Alert(
                title: Text("Are you sure you want to delete this goal?"),
                message: Text("You cannot undo this later, '\(goal.name)' will be lost forever!"),
                primaryButton: .default(
                    Text("Delete"),
                    action: {
                        modelContext.delete(goal)
                        try? modelContext.save()
                        // Reset selection
                        selection = nil 
                    }
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
            AddEditTransactionSheet(goal: goal, onSave: { _ in
                // If goal is now complete, show confetti
                if (goal.percentage >= 1) {
                    confettiTrigger.toggle()
                }
            })
            #if os(iOS)
                .presentationDetents([.medium, .large])
            #endif
        }
        // Edit transaction sheet
        .sheet(item: $transactionToEdit) { transaction in
            AddEditTransactionSheet(goal: goal, transactionToEdit: transaction, onSave: { _ in
                // If goal is now complete, show confetti
                if (goal.percentage >= 1) {
                    confettiTrigger.toggle()
                }
            })
            #if os(iOS)
                .presentationDetents([.medium, .large])
            #endif
        }
    }
    
    func sorter(_ lhs: FiscalTransaction, _ rhs: FiscalTransaction) -> Bool {
        switch transactionSortOption {
        case .amount: return transactionSortOrder.sort(lhs.amount, rhs.amount)
        case .date: return transactionSortOrder.sort(lhs.date, rhs.date)
        case .name: return transactionSortOrder.sort(lhs.name, rhs.name)
        }
    }
    
    var transactionSortSelector: some View {
        Menu {
            // Sort by
            Menu {
                Picker("Sort by", selection: $transactionSortOption) {
                    ForEach(FiscalTransactionSortOption.allCases) { order in
                        order.labelView().tag(order)
                    }
                }
                .pickerStyle(.inline)
            } label: {
                Label("Sort by", systemImage: "hand.point.up.left.and.text")
                Text(transactionSortOption.rawValue)
            }
            // Sort order
            Menu {
                Picker("Sort order", selection: $transactionSortOrder) {
                    ForEach(AsideSortOrder.allCases.reversed()) { order in
                        order.labelView().tag(order)
                    }
                }
                .pickerStyle(.inline)
            } label: {
                Label("Sort order", systemImage: "arrow.up.arrow.down")
                Text(transactionSortOrder.rawValue)
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down.circle")
                .labelStyle(.iconOnly)
                .font(.title3)
        }
    }
}
