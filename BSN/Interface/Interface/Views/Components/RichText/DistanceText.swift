//
//  DistanText.swift
//  Interface
//
//  Created by Phucnh on 10/6/20.
//

import SwiftUI

struct DistanceText: View {
    
    var distance: Float // in met unit
    
    var body: some View {
        Text("Khoảng cách: \(getDistance())")
            .robotoLight(size: 13)
    }
    
    func getDistance() -> String {
        if distance > 1000 {
            return "\(String(format: "%.1f", distance / 1000)) Km"
        } else {
            return "\(String(format: "%.0f", distance)) m"
        }
    }
}

struct DistanceText_Previews: PreviewProvider {
    static var previews: some View {
        DistanceText(distance: 3600)
    }
}
