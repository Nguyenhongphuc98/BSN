//
//  LoadingFullScreen.swift
//  Interface
//
//  Created by Phucnh on 11/17/20.
//

import SwiftUI

struct LoadingFullScreen: View {
    
    @State private var animate: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                }
            }
            .background(Color.white)
            
            Circle()
                .trim(from: 0, to: 0.8)
                .stroke(AngularGradient(gradient: .init(colors: [._primary, .white]), center: .center), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .frame(width: 40, height: 40)
                .rotationEffect(.init(radians: animate ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear(perform: self.viewAppead)
                .onDisappear(perform: self.viewDisAppead)
        }
    }
    
    func viewAppead() {
        animate = true
    }
    
    func viewDisAppead() {
        animate = false        
    }
}

struct LoadingFullScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingFullScreen()
    }
}
