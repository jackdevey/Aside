    //
//  ExportAppDataButton.swift
//  Aside
//
//  Created by Jack Devey on 03/07/2025.
//

import SwiftUI
import UniformTypeIdentifiers
import SwiftData

struct DeleteAppDataButton: View {
    @Environment(\.modelContext) var modelContext
    @State private var exportURL: URL?
    @State private var showShareSheet = false
    
    @State private var showingDeleteAlert = false

    var body: some View {
        Button {
            showingDeleteAlert = true
        } label: {
            Label("Delete", systemImage: "trash")
        }
        // Deletion alert
        .alert("Are you sure you want to delete all app data?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                deleteData()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This action cannot be undone. All your data will be permanently removed.")
        }
    }

    func deleteData() {
        do {
            // Get all goals
            let goals = try modelContext.fetch(FetchDescriptor<Goal>())
            // Iterate over and delete
            for item in goals {
                modelContext.delete(item)
            }
            // Try to save changes
            try modelContext.save()
            print("App data deleted.")
        } catch {
            print("Failed to delete data: \(error.localizedDescription)")
        }
    }
}
