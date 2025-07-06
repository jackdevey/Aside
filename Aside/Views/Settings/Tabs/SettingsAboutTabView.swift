//
//  AboutTabView.swift
//  Aside
//
//  Created by Jack Devey on 06/07/2025.
//

import SwiftUI

struct License: Identifiable {
    let id = UUID()
    let title: String
    let text: String
}

struct SettingsAboutTabView: View {
    
    // Include licenses state for macOS in-app license viewer
    @State private var licenses: [License] = []
    @State private var selectedLicense: License? = nil
    
    var body: some View {
        Form {
            Section(
                header: Text("About App")
            ) {
                HStack {
                    AppIconView()
                        .frame(width: 24, height: 24)
                    Text("Aside for \(software)")
                    Spacer()
                    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        Text("v\(version)")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            Section(
                header: Text("Acknowledgments")
            ) {
                acknowledgements
            }
        }
        .navigationTitle("About")
    }
    
    var label: some View {
        Label("About", systemImage: "info.circle")
    }
    
    var software: String {
        #if os(iOS)
        "iOS"
        #elseif os(macOS)
        "macOS"
        #else
        "Unknown OS"
        #endif
    }
    
    var acknowledgements: some View {
        #if os(macOS)
        List(licenses) { license in
            Button {
                selectedLicense = license
            } label: {
                Text(license.title)
            }
        }
        .onAppear(perform: loadLicenses)
        // Show a quick sheet with close button to view the license
        .sheet(item: $selectedLicense) { license in
            NavigationStack {
                ScrollView {
                    Text(license.text)
                        .padding()
                }
            }
            .navigationTitle(license.title)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        selectedLicense = nil
                    } label: {
                        Text("Close")
                    }
                }
            }
        }
        #elseif os(iOS)
        // Can't access Settings.bundle on iOS from inside app so have to include link
        // to where it is displayed in system settings
        Button {
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        } label: {
            Label("View in system settings", systemImage: "arrow.up.forward.square")
        }
        #endif
    }
    
    private func loadLicenses() {
        print("🔍 Attempting to load licenses...")

        guard let settingsBundlePath = Bundle.main.path(forResource: "Settings", ofType: "bundle"),
              let settingsBundle = Bundle(path: settingsBundlePath),
              let plistPath = settingsBundle.path(forResource: "com.mono0926.LicensePlist", ofType: "plist"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: plistPath)),
              let topLevelPlist = try? PropertyListSerialization.propertyList(from: data, format: nil) as? [String: Any],
              let items = topLevelPlist["PreferenceSpecifiers"] as? [[String: Any]]
        else {
            print("❌ Failed to load or parse LicensePlist main plist")
            return
        }

        print("✅ Loaded PreferenceSpecifiers list with \(items.count) items")

        var loadedLicenses: [License] = []

        for item in items {
            guard let type = item["Type"] as? String, type == "PSChildPaneSpecifier",
                  let file = item["File"] as? String,
                  let title = item["Title"] as? String,
                  let licensePlistPath = settingsBundle.path(forResource: file, ofType: "plist")
            else {
                print("⚠️ Skipping invalid or missing child plist entry: \(item)")
                continue
            }

            print("📄 Loading child plist for: \(title) at \(licensePlistPath)")

            do {
                let licenseData = try Data(contentsOf: URL(fileURLWithPath: licensePlistPath))
                let rawPlist = try PropertyListSerialization.propertyList(from: licenseData, format: nil)

                if let dict = rawPlist as? [String: Any],
                   let specifiers = dict["PreferenceSpecifiers"] as? [[String: Any]],
                   let firstItem = specifiers.first,
                   let footerText = firstItem["FooterText"] as? String {

                    print("✅ Loaded license: \(title)")
                    loadedLicenses.append(License(title: title, text: footerText))

                } else {
                    print("⚠️ Unexpected format or missing FooterText in child plist")
                }

            } catch {
                print("❌ Failed to parse child plist for \(title): \(error)")
            }
        }

        licenses = loadedLicenses
        print("✅ Final license count: \(licenses.count)")
    }
}
