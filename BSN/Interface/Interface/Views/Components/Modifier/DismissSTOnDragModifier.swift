//
//  DismissSTOnDragModifier.swift
//  Interface
//
//  Created by Phucnh on 10/4/20.
//

import SwiftUI

struct DismissSTOnDragModifier: ViewModifier {
    
    @Binding var isShowing: Bool
    
    func body(content: Content) -> some View {
        content.gesture(DragGesture().onChanged{_ in
            isShowing.toggle()
        })
    }
}

extension View {
    func resignSTOnDragGesture(showing: Binding<Bool>) -> some View {
        return modifier(DismissSTOnDragModifier(isShowing: showing))
    }
}
