//
//  DataDunctions.swift
//  Aside
//
//  Created by Jack Devey on 03/08/2022.
//

import Foundation
import SwiftUI

struct DataFunctions {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    func newGoal(name: String, target: Float, sfIconName: String) async {
        await viewContext.perform({
            let goal = Goal(context: viewContext)
            goal.id = UUID()
            goal.name = name
            goal.sfIconName = sfIconName
            goal.target = target
            goal.saved = 0
            goal.currency = "£"
            
        })
        try? PersistanceController.shared.saveContext()
    }
}
