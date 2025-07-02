//
//  Transaction.swift
//  Aside
//
//  Created by Jack Devey on 21/06/2025.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class FiscalTransaction: Identifiable {
    
    var id: UUID = UUID()
    var amount: Float = 0.0
    var name: String = "Unnamed Transaction"
    var category: FiscalTransactionCategory = FiscalTransactionCategory.other
    var date: Date = Date.now
    
    @Relationship(inverse: \Goal._transactions)
    var _goal: Goal?
    
    init(amount: Float, name: String, category: FiscalTransactionCategory, goal: Goal) {
        self.amount = amount
        self.name = name
        self.category = category
        self._goal = goal
    }
    
    public var goal: Goal {
        return self._goal!
    }
    
}

enum FiscalTransactionCategory: String, CaseIterable, Identifiable, Codable {
    case paycheck
    case cashback
    case gift
    case roundUp
    case transfer
    case interest
    case refund
    case bonus
    case other

    var id: String { self.rawValue }

    @ViewBuilder
    func labelView() -> some View {
        switch self {
        case .paycheck:
            Label("Paycheck", systemImage: "banknote.fill")
        case .cashback:
            Label("Cashback", systemImage: "creditcard.fill")
        case .gift:
            Label("Gift", systemImage: "gift.fill")
        case .roundUp:
            Label("Round-Up", systemImage: "arrow.triangle.2.circlepath.circle.fill")
        case .transfer:
            Label("Transfer", systemImage: "arrow.right.arrow.left.square")
        case .interest:
            Label("Interest", systemImage: "percent")
        case .refund:
            Label("Refund", systemImage: "arrow.uturn.left.circle.fill")
        case .bonus:
            Label("Bonus", systemImage: "sparkles")
        case .other:
            Label("Other", systemImage: "questionmark.circle.fill")
        }
    }

}
