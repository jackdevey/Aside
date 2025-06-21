//
//  AddEditTransactionSheet.swift
//  Aside
//
//  Created by Jack Devey on 21/06/2025.
//

import SwiftUI
import SwiftData

struct AddEditTransactionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var goal: Goal
    var transactionToEdit: FiscalTransaction?

    @State private var name: String = ""
    @State private var amount: Float = 0.0
    @State private var category: FiscalTransactionCategory = .transfer
    
    var isEditing: Bool {
        transactionToEdit != nil
    }

    var body: some View {
        VStack {
            HStack {
                Text(isEditing ? "Edit Transaction" : "New Transaction")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding([.top, .leading, .trailing])
            .padding(.bottom, 5)

            Divider()

            Form {
                Section(header: Text("Info")) {
                    TextField("Amount", value: $amount, format: .currency(code: "GBP"))
                    TextField("Name", text: $name)
                }
                Section(header: Text("Category")) {
                    Picker("Category", selection: $category) {
                        ForEach(FiscalTransactionCategory.allCases, id: \.rawValue) { category in
                            category.labelView()
                                .tag(category)
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let existing = transactionToEdit {
                            existing.name = name
                            existing.amount = amount
                        } else {
                            let transaction = FiscalTransaction(
                                amount: amount,
                                name: name,
                                category: category,
                                goal: goal
                            )
                            // Insert & save
                            modelContext.insert(transaction)
                            try? modelContext.save()
                        }
                        dismiss()
                    }
                    .disabled(name.isEmpty || amount.isZero)
                }
            }
        }
        .onAppear {
            if let transaction = transactionToEdit {
                name = transaction.name
                amount = transaction.amount
                category = transaction.category
            }
        }
    }
}
