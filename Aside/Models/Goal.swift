//
//  Goal+CoreDataClass.swift
//  Aside
//
//  Created by Jack Devey on 02/08/2022.
//
//

import Foundation
import CoreData
import SwiftData
import SwiftUI

@Model
class Goal: Identifiable {
    
    var id: UUID = UUID()
    var name: String = "Unnamed Goal"
    var sfIcon: String = "questionmark.square.dashed"
    var target: Float = 0.0
    var due: Date?
    var created: Date = Date.now
    
    @Relationship(deleteRule: .cascade, originalName: "transactions") var _transactions: [FiscalTransaction]?
    
    init(name: String, sfIcon: String, target: Float, due: Date? = nil) {
        self.name = name
        self.sfIcon = sfIcon
        self.target = target
        self.due = due
        self._transactions = []
    }
    
    public var transactions: [FiscalTransaction] {
        return _transactions ?? []
    }
    
    public var saved: Float {
        var total: Float = 0
        
        for log in transactions {
            total += log.amount
        }
        
        return total
    }
    
    public var percentage: Float {
        return (saved / target)
    }
    
    @ViewBuilder
    func progressCircle() -> some View {
        ZStack {
            Circle()
                .stroke(.tertiary, lineWidth: 3)
                .frame(width: 18, height: 18)
            Circle()
                .trim(from: 0.0, to: Double(percentage))
                .stroke(.accent, lineWidth: 3)
                .frame(width: 18, height: 18)
                .rotationEffect(Angle(degrees: -90))
        }
    }
}
