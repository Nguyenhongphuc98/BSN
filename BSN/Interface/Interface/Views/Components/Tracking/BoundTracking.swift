//
//  BoundTracking.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

struct BoundGetter: View {
    
    var body: some View {
        GeometryReader { proxy in
                Color.clear.preference(key: BoundPreferenceKey.self, value: [BoundPreferenceData(bounds: proxy.frame(in : .global))])
        }
    }
}

struct BoundPreferenceKey: PreferenceKey {
    
    static var defaultValue: [BoundPreferenceData] = []
    
    static func reduce(value: inout [BoundPreferenceData], nextValue: () -> [BoundPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
    
}

struct BoundPreferenceData: Equatable {
    let bounds: CGRect
}
