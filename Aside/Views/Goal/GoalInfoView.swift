//
//  GoalInfoView.swift
//  Aside
//
//  Created by Jack Devey on 16/07/2025.
//

import SwiftUI
import ConfettiSwiftUI

struct GoalInfoView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var settings = SettingsManager.shared
    
    var goal: Goal
    
    @Binding var deleteAlert: Bool
    @Binding var editSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            // Goal name & icon
            #if os(iOS)
            HStack {
                Image(systemName: goal.sfIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.accent)
                Text(goal.name)
                    .font(.title2)
                    .bold()
                    .lineLimit(1)
                    .layoutPriority(1)
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
                    Group {
                        #if os(macOS)
                        Label("Options", systemImage: "ellipsis")
                        #else
                        Label("Options", systemImage: "ellipsis.circle.fill")
                        #endif
                    }
                    .symbolRenderingMode(.hierarchical)
                    .labelStyle(.iconOnly)
                    .font(.title2)
                }
                .fixedSize()
            }
            #endif
            // Progress view
            ProgressView(value: max(0, min(goal.percentage, 1)), total: 1) {
                HStack {
                    Text("\(max(0, min(goal.percentage, 1)), format: .percent.precision(.fractionLength(0...2))) completed")
                    // Add an extra amount if over saved
                    if goal.isOverSaved {
                        Text("+ \(goal.overSaveAmount, format: .currency(code: settings.currencyCode)) extra")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            #if os(iOS)
            .padding(.top, 5)
            #endif
        }
        .padding([.top, .bottom], 5)
        HStack {
            Text("Saved")
            Spacer()
            Text(goal.saved, format: .currency(code: settings.currencyCode))
        }
        HStack {
            Text("Target")
            Spacer()
            Text(goal.target, format: .currency(code: settings.currencyCode))
        }
    }
}
