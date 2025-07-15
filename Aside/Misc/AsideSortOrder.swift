//
//  SortOrder.swift
//  Aside
//
//  Created by Jack Devey on 15/07/2025.
//

import SwiftUI

enum AsideSortOrder: String, CaseIterable, Identifiable {
    case descending = "Descending"
    case ascending = "Ascending"
    
    var id: String { self.rawValue }
    
    @ViewBuilder
    func labelView() -> some View {
        Text(self.rawValue)
    }
    
    public func sort<T: Comparable>(_ lhs: T, _ rhs: T) -> Bool {
        switch self {
        case .ascending:
            return lhs < rhs
        case .descending:
            return lhs > rhs
        }
    }
}
