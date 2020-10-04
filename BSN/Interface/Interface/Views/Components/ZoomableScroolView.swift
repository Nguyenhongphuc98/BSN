//
//  ZoomableScroolView.swift
//  Interface
//
//  Created by Phucnh on 9/29/20.
//

import SwiftUI

struct ZoomableScrollImage: View {
    
    var url: String?
    
    var data: Data?
    
    var didRequestOutScreen: (() -> Void)?
    
    var maxScale: CGFloat = 3
    
    @State private var scale: CGFloat = 1.0
    
    @State private var lastScale: CGFloat = 1.0
    
    @State private var preDraging: CGPoint = .zero
    
    @State private var originSize: CGSize = .zero
    
    private var xFactor: CGFloat {
        ((originSize.width / 2) * (scale - 1) - (UIScreen.screenWidth - originSize.width) / 2) / scale
    }
    
    private var yFactor: CGFloat {
        ((originSize.height / 2) * (scale - 1) - (UIScreen.screenHeight - originSize.height) / 2) / scale
    }
    
    @State private var offset: CGPoint = .zero
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { proxy in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .animation(.spring())
                    .offset(x: offset.x, y: offset.y)
                    .gesture(
                        DragGesture()
                            .onChanged { val in
                                // Caculate real transition
                                offset.x = preDraging.x + val.translation.width
                                offset.y = preDraging.y + val.translation.height
                            }
                            .onEnded({ (val) in
                                
                                withAnimation(.spring()) {
                                    // Out screen or go back origin position
                                    if scale == 1 {
                                        if abs(offset.x) > 80 || abs(offset.y) > 80 {
                                            didRequestOutScreen?()
                                        }
                                        
                                        offset = .zero
                                    } else {
                                        // Don't let space in h and v
                                        offset.x = max(min(offset.x, xFactor), -xFactor)
                                        offset.y = max(min(offset.y, yFactor), -yFactor)
                                    }
                                }
                                
                                preDraging = offset
                            })
                    )
                    //                .gesture(MagnificationGesture()
                    //                            .onChanged { val in
                    //                                let delta = val / self.lastScale
                    //                                self.lastScale = val
                    //                                if delta > 0.94 { // if statement to minimize jitter
                    //                                    let newScale = self.scale * delta
                    //                                    self.scale = newScale
                    //                                }
                    //                            }
                    //                            .onEnded { _ in
                    //                                self.lastScale = 1.0
                    //                            }
                    //                )
                    .onTapGesture(count: 2, perform: {
                        withAnimation {
                            if scale == 1 {
                                scale = maxScale
                            } else {
                                
                                // Elapsed image to origin size and position
                                scale = 1
                                offset = .zero
                            }
                        }
                    })
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .scaleEffect(scale)
                    .onReload {
                        caculateRealImageSize(size: proxy.size)
                    }
            }
            
            Button(action: {
                didRequestOutScreen?()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            })
            .padding()
        }
        .background(Color.init(hex: 0x3C3C3C))
        .edgesIgnoringSafeArea(.all)
    }
    
    var image: Image {
        (url != nil) ? Image(url!, bundle: interfaceBundle) : Image(uiImage: UIImage(data: data!)!)
    }
    
    func caculateRealImageSize(size: CGSize) {
        if originSize == .zero {
            
            self.originSize = size
            
            // Recaculate actual size
            let uiimage: UIImage
            if url != nil {
                uiimage = UIImage(named: url!, in: interfaceBundle, with: nil)!
            } else {
                uiimage = UIImage(data: data!)!
            }
            
            let screenRatio = UIScreen.screenWidth / UIScreen.screenHeight
            let wr = uiimage.size.width / uiimage.size.height
            
            
            if wr > screenRatio {
                // caculate by w
                self.originSize.height = originSize.width / wr
            } else {
                // caculate by h
                self.originSize.width = originSize.height * wr
            }
            
            print("origin size: \(originSize)")
        }
    }
}
