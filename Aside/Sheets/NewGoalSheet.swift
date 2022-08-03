//
//  NewGoalSheet.swift
//  Aside
//
//  Created by Jack Devey on 02/08/2022.

import Foundation
import SwiftUI
import Combine

struct NewGoalSheet: View {
    
    // Keep track of if the sheet should be shown
    @Binding var isPresented: Bool
    
    // Called when the sheet is done
    var onFinish: (String, Float, String) -> ()
    
    // The name of the goal
    @State var name: String = ""
    // The target value for the goal
    @State var target: Float = 0
    // The icon for the goal
    @State var icon: String = "square"
    
    // The title of the sheet
    var title: String  = "New goal"
    
    // The subheading of the sheet
    var subheading: String = "Create a new goal to begin saving"
    
    // The text for the finish button
    var finish: String = "Create"
    
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
                IconPicker(icon: $icon)
            }
            Divider()
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            HStack {
                Button("Close", role: .cancel) { isPresented = false }
                Button(finish) {
                    onFinish(name, target, icon)
                    isPresented = false
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
