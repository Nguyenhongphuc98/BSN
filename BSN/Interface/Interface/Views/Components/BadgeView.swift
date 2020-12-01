//
//  BadgeView.swift
//  Interface
//
//  Created by Phucnh on 12/1/20.
//

import SwiftUI

public struct BadgeView: View {
    
    @ObservedObject var app: AppManager = .shared
    
    let type: TabItemType
    
    var numUnread: Int {
        type == .chat ? app.numUnReadMessage : app.numUnReadNotify
    }
    
    public init(type: TabItemType) {
        self.type = type
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.red)
            
            Text("\(numUnread)")
                .foregroundColor(.white)
                .font(Font.system(size: 12))
        }
        .frame(width: 15, height: 15)
        .opacity(numUnread == 0 ? 0 : (app.keyboardHeight == 0 ? 1.0 : 0)) // when keyboard show, tabview will auto hidden, we should clear this sign
        .allowsTightening(false)
    }
}
