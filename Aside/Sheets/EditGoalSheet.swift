//
//  EditGoalSheet.swift
//  Aside
//
//  Created by Jack Devey on 03/08/2022.
//

import Foundation
import SwiftUI
import Combine

struct EditGoalSheet: View {
    
    // Called when the sheet is cancelled
    var onClose: () -> ()
    
    // Called when the sheet is done
    var onFinish: (String, Float, String) -> ()
    
    // The name of the goal
    @State var name: String
    // The target value for the goal
    @State var target: Float
    // The icon for the goal
    @State var icon: String
    
    // The title of the sheet
    var title: String  = "Edit goal"
    
    // The subheading of the sheet
    var subheading: String = "Update the details of a goal"
    
    // The text for the finish button
    var finish: String = "Save"
    
    // Number formatter for currency
    var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    var body: some View {
        
        VStack {
            Text(title)
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(subheading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.secondary)
            Divider()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            Form {
                TextField("Name:", text: $name)
                TextField("Target:", value: $target, formatter: formatter)
                Picker("Icon:", selection: $icon) {
                    Image(systemName: "square").tag("square")
                    Image(systemName: "iphone").tag("iphone")
                    Image(systemName: "house").tag("house")
                    Image(systemName: "headphones").tag("headphones")
                }
            }
            Divider()
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            HStack {
                Button("Close", role: .cancel) { onClose() }
                Button(finish) {
                    onFinish(name, target, icon)
                    onClose()
                }
                .disabled(name.isEmpty || target == 0)
                .tint(.accentColor)
            }
            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .frame(width: 300, alignment: .leading)
    }
}