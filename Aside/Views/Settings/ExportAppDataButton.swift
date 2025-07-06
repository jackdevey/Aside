//
//  ExportAppDataButton.swift
//  Aside
//
//  Created by Jack Devey on 03/07/2025.
//

import SwiftUI
import UniformTypeIdentifiers
import SwiftData

struct ExportAppDataButton: View {
    @Environment(\.modelContext) var modelContext
    @State private var exportURL: URL?
    @State private var showShareSheet = false

    var body: some View {
        Button {
            exportData()
        } label: {
            Label("Export", systemImage: "square.and.arrow.down")
        }
        // iOS and Mac Catalyst share sheet via UIViewControllerRepresentable
        .sheet(isPresented: $showShareSheet) {
            if let url = exportURL {
                #if os(iOS)
                ShareSheet(activityItems: [url])
                #elseif targetEnvironment(macCatalyst)
                ShareSheet(activityItems: [url])
                #endif
            }
        }
        // On native macOS, trigger NSSharingServicePicker manually
        .background {
            if let url = exportURL, !showShareSheet {
                #if os(macOS)
                SharingPickerView(url: url)
                #endif
            }
        }
    }

    func exportData() {
        do {
            let goals = try modelContext.fetch(FetchDescriptor<Goal>())
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(goals)

            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("goals.json")
            try data.write(to: tempURL)
            exportURL = tempURL

            #if os(macOS)
            // On macOS, trigger native share picker
            showShareSheet = false
            #else
            // On iOS and Mac Catalyst, present share sheet modally
            showShareSheet = true
            #endif
        } catch {
            print("Export failed: \(error)")
        }
    }
}

#if os(iOS) || targetEnvironment(macCatalyst)
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
#endif

#if os(macOS)
struct SharingPickerView: NSViewRepresentable {
    let url: URL

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            let picker = NSSharingServicePicker(items: [url])
            picker.show(relativeTo: .zero, of: view, preferredEdge: .minY)
        }
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}
#endif
