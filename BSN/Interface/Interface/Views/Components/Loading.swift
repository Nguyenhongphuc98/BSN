//
//  Loading.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

struct Loading: View {
    
    @State private var animate: Bool = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.8)
            .stroke(AngularGradient(gradient: .init(colors: [._primary, .white]), center: .center), style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .frame(width: 20, height: 20)
            .rotationEffect(.init(radians: animate ? 360 : 0))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
            .onAppear(perform: self.viewAppead)
            .onDisappear(perform: self.viewDisAppead)
    }
    
    func viewAppead() {
        animate = true
        print("loading apeard")
    }
    
    func viewDisAppead() {
        animate = false
        print("loading DisApeard")
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
    }
}
