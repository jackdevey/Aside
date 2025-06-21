//
//  AddEditGoalSheet.swift
//  Aside
//
//  Created by Jack Devey on 21/06/2025.
//

import SwiftUI
import SwiftData
import SymbolPicker

struct AddEditGoalSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var goalToEdit: Goal?

    @State private var name: String = ""
    @State private var sfIcon: String = "ellipsis"
    @State private var target: Float = 0.0
    @State private var due: Date = Date.now
    
    @State private var hasDueDate: Bool = false

    var isEditing: Bool {
        goalToEdit != nil
    }
    
    @State private var showingIconSelectorSheet: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text(isEditing ? "Edit Goal" : "New Goal")
                    .font(.title2)
                    .bold()
                Spacer()
            }
            .padding([.top, .leading, .trailing])
            .padding(.bottom, 5)

            Divider()

            Form {
                Section(header: Text("Info")) {
                    TextField("Name", text: $name)
                    HStack {
                        Text("Icon")
                        Spacer()
                        Button {
                            showingIconSelectorSheet.toggle()
                        } label: {
                            Image(systemName: sfIcon)
                        }
                    }
                }
                
                Section(header: Text("Target")) {
                    TextField("Amount", value: $target, format: .currency(code: "GBP"))
                }
                
                Section(header: Text("Due Date")) {
                    Toggle(isOn: $hasDueDate) {
                        Text("Goal has a due date")
                    }
                    if hasDueDate {
                        DatePicker("Due Date", selection: $due)
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
                        if let existing = goalToEdit {
                            existing.name = name
                            existing.sfIcon = sfIcon
                            existing.target = target
                            existing.due = hasDueDate ? due : nil
                        } else {
                            let goal = Goal(
                                name: name,
                                sfIcon: sfIcon,
                                target: target,
                                due: hasDueDate ? due : nil
                            )
                            // Insert & save
                            modelContext.insert(goal)
                            try? modelContext.save()
                        }
                        dismiss()
                    }
                    .disabled(name.isEmpty || sfIcon.isEmpty || target.isZero || (hasDueDate && Date.now < due))
                }
            }
        }
        .onAppear {
            if let goal = goalToEdit {
                name = goal.name
                sfIcon = goal.sfIcon
                target = goal.target
                due = goal.due != nil ? goal.due! : due // Only set due if the value on goal is set
            }
        }
        .sheet(isPresented: $showingIconSelectorSheet) {
            SymbolPicker(symbol: $sfIcon)
        }
    }
}
