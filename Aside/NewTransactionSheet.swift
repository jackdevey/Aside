//
//  NewTransactionSheet.swift
//  Aside
//
//  Created by Jack Devey on 02/08/2022.
//

import Foundation
import SwiftUI
import Combine

struct NewTransactionSheet: View {
    
    var onClose: () -> ()
    var onCreate: (String, Float, Date, Bool) -> ()
    
    @State var name: String = ""
    @State var ammount: Float = 0
    @State var currency: String = "gbp"
    @State var direction: Bool = true
    @State var date: Date = Date.now
    
    var formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            return formatter
        }()
    
    var body: some View {
        
        VStack {
            Text("New Transaction")
                .font(.title)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Record your latest step towards your goal")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.secondary)
            Divider()
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            Form {
                TextField("Name:", text: $name)
                TextField("Ammount:", value: $ammount, formatter: formatter)
            }
            Divider()
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            HStack {
                Button("Close", role: .cancel) { onClose() }
                Button("Create") {
                    onCreate(name, ammount, date, direction)
                    onClose()
                }
                .disabled(name.isEmpty || ammount == 0)
                .tint(.accentColor)
            }
            .frame(maxWidth: .infinity, alignment: .bottomTrailing)
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .frame(width: 300, alignment: .leading)
    }
}
