//
//  Goal+CoreDataClass.swift
//  Aside
//
//  Created by Jack Devey on 01/08/2022.
//

import Foundation
import CoreData

@objc(Goal)
public class Goal: NSManagedObject, Identifiable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }
    
    @nonobjc class func fetchRequest(forID id:UUID) -> NSFetchRequest<Goal> {
        let request = Goal.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        return request
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var sfIconName: String
    @NSManaged public var target: Float
    @NSManaged public var saved: Float
    @NSManaged public var currency: String
    @NSManaged public var transactions: NSSet
    
}

@objc(ProgressTransaction)
public class ProgressTransaction: NSManagedObject, Identifiable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgressTransaction> {
        return NSFetchRequest<ProgressTransaction>(entityName: "Transaction")
    }
    
    @nonobjc class func fetchRequest(forID id:UUID) -> NSFetchRequest<ProgressTransaction> {
        let request = ProgressTransaction.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        return request
    }
    
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var ammount: Float
    @NSManaged public var direction: Bool
    @NSManaged public var date: Date
    
}
