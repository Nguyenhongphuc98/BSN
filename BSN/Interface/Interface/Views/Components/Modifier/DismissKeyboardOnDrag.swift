//
//  DismissKeyboardOnDrag.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI

struct DismissKeyboardOnDrag: ViewModifier {
    
    var gesture = DragGesture().onChanged{_ in
        UIApplication.shared.endEditing(true)
    }
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(DismissKeyboardOnDrag())
    }
}
