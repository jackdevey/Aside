//
//  SettingsManager.swift
//  Aside
//
//  Created by Jack Devey on 22/06/2025.
//

import SwiftUI
import Combine

class SettingsManager: ObservableObject {
    static let shared = SettingsManager()

    @Published var currencyCode: String {
        didSet {
            UserDefaults.standard.set(currencyCode, forKey: "currencyCode")
        }
    }

    private init() {
        // Default to locale currency or GBP
        self.currencyCode = UserDefaults.standard.string(forKey: "currencyCode")
            ?? Locale.current.currency?.identifier ?? "GBP"
    }
}
