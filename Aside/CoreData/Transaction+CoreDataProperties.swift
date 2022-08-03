//
//  Transaction+CoreDataProperties.swift
//  Aside
//
//  Created by Jack Devey on 02/08/2022.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var direction: Bool
    @NSManaged public var name: String?
    @NSManaged public var ammount: Float
    @NSManaged public var forGoal: Goal?
    
    public var wName: String {
        name ?? "Unkown"
    }
    
    public var wDate: Date {
        date ?? Date.now
    }
    
    public var ammountString: String {
        var plusmin = "+"
        if !direction {plusmin = "-"}
        
        return "\(plusmin)\(ammount)"
    }
    
    public var dateString: String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .short
        return df.string(from: wDate)
    }

}

extension Transaction : Identifiable {

}
