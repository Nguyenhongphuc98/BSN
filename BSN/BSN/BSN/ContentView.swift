//
//  ContentView.swift
//  BSN
//
//  Created by Phucnh on 9/21/20.
//

import SwiftUI
import Interface
import Component

struct ContentView: View {
    var body: some View {
        Text("BSN")
            .padding()
            .onAppear(perform: {
                let a = Lauch()
                a.load()
                let b = ComponentFile()
                b.load()
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
