//
//  LoadingFullScreen.swift
//  Interface
//
//  Created by Phucnh on 11/17/20.
//

import SwiftUI

struct LoadingFullScreen: View {
    
    var body: some View {
        ZStack(alignment: .center) {
            HStack() {
                Spacer()
                VStack {
                    Spacer()
                }
            }            
            .background(Color.white)
                        
            CircleLoading(frame: CGSize(width: 40, height: 40))
        }
    }
}

struct CircleLoading: View {
    
    @State private var animate: Bool = false
    
    var frame: CGSize = CGSize(width: 30, height: 30)
    
    var body: some View {
        
        Circle()
            .trim(from: 0, to: 0.8)
            .stroke(AngularGradient(gradient: .init(colors: [._primary, .white]), center: .center), style: StrokeStyle(lineWidth: 3, lineCap: .round))
            .frame(width: frame.width, height: frame.height)
            .rotationEffect(.init(degrees: animate ? 360 : 0))
            .animation(Animation.easeIn(duration: 0.6).repeatForever(autoreverses: false))
            .onAppear(perform: self.viewAppead)
    }
    
    func viewAppead() {
        animate.toggle()
    }
}
