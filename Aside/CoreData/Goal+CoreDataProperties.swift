//
//  Goal+CoreDataProperties.swift
//  Aside
//
//  Created by Jack Devey on 02/08/2022.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var currency: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var sfIconName: String?
    @NSManaged public var target: Float
    @NSManaged public var saved: Float
    @NSManaged public var transactions: NSOrderedSet?
    @NSManaged public var date: Date?
    
    public var transactionLog: [Transaction] {
        
        let array = transactions?.array as? [Transaction] ?? []
        
        return array.reversed()
    }
    
    public var progress: Float {
        var total: Float = 0
        
        for log in transactionLog {
            if(log.direction) {
                total += log.ammount
                
            } else {
                total -= log.ammount
            }
        }
        
        return total
    }
    
    public var percentageString: String {
        return "\(String(format: "%.0f", (percentage) * 100))%"
    }
    
    public var remainingString: String {
        return String(format: "%.2f", target - progress)
    }
    
    public var percentage: Float {
        return (progress / target)
    }
    
    public var wDate: Date {
        return date ?? Date.init(timeIntervalSince1970: 0)
    }


}

// MARK: Generated accessors for transactions
extension Goal {

    @objc(insertObject:inTransactionsAtIndex:)
    @NSManaged public func insertIntoTransactions(_ value: Transaction, at idx: Int)

    @objc(removeObjectFromTransactionsAtIndex:)
    @NSManaged public func removeFromTransactions(at idx: Int)

    @objc(insertTransactions:atIndexes:)
    @NSManaged public func insertIntoTransactions(_ values: [Transaction], at indexes: NSIndexSet)

    @objc(removeTransactionsAtIndexes:)
    @NSManaged public func removeFromTransactions(at indexes: NSIndexSet)

    @objc(replaceObjectInTransactionsAtIndex:withObject:)
    @NSManaged public func replaceTransactions(at idx: Int, with value: Transaction)

    @objc(replaceTransactionsAtIndexes:withTransactions:)
    @NSManaged public func replaceTransactions(at indexes: NSIndexSet, with values: [Transaction])

    @objc(addTransactionsObject:)
    @NSManaged public func addToTransactions(_ value: Transaction)

    @objc(removeTransactionsObject:)
    @NSManaged public func removeFromTransactions(_ value: Transaction)

    @objc(addTransactions:)
    @NSManaged public func addToTransactions(_ values: NSOrderedSet)

    @objc(removeTransactions:)
    @NSManaged public func removeFromTransactions(_ values: NSOrderedSet)

}

extension Goal : Identifiable {

}
