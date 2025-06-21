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

@Model
class Goal: Identifiable {
    
    var id: UUID
    var name: String
    var sfIcon: String
    var target: Float
    var due: Date?
    var created: Date
    
    @Relationship(inverse: \FiscalTransaction.goal) var transactions: [FiscalTransaction]
    
    init(name: String, sfIcon: String, target: Float, due: Date? = nil) {
        self.id = UUID()
        self.name = name
        self.sfIcon = sfIcon
        self.target = target
        self.due = due
        self.created = Date.now
        self.transactions = []
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
    
}
