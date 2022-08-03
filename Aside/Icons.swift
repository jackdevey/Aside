//
//  Icons.swift
//  Aside
//
//  Created by Jack Devey on 03/08/2022.
//

import Foundation
import SwiftUI

enum Icons: String, CaseIterable {
    case display = "display"
    case phone = "iphone.rear.camera"
    case headphones = "headphones"
    case camera = "camera"
    case house = "house"
    case controller = "gamecontroller"
    case car = "car"
    case pet = "pawprint"
    case cross = "cross"
}

struct IconPicker: View {
    
    // Icon selection from parent
    @Binding var icon: String
    
    var body: some View {
        Picker("Icon:", selection: $icon) {
            // Iterate through icons
            ForEach(Icons.allCases, id:\.rawValue) { icon in
                Image(systemName: icon.rawValue).tag(icon.rawValue)
            }
        }
    }
}
