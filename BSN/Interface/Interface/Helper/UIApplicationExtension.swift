//
//  UIApplicationExtension.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter{$0.isKeyWindow}
            .first?
            .endEditing(force)
    }
}
