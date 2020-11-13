//
//  FloatExtension.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import Foundation

extension Float {
    
    // Get int value, round to down
    var div: Int {
        var r = self
        r.round(.down)
        return Int(r)
    }
    
    // Get remainder Float value
    // Divide for smaller Int value closest,
    var remain: Float {
        div == 0 ? 0 : self.remainder(dividingBy: Float(div))
    }
    
    // Remain star in total
    func lastStar(total: Int) -> Int {
        total - Int(self.rounded(.up))
    }
}
