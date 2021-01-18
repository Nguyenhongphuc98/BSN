//
//  ImageWithCloseBtn.swift
//  Interface
//
//  Created by Phucnh on 1/9/21.
//

import SwiftUI

struct ImageWithCloseBtn: View {
    
    @Binding var photoUrl: String
    
    var frame: CGSize = CGSize(width: 170, height: 120)
    var isRemote: Bool = true
    
    var didClose: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Group {
                if isRemote {
                    BSNImage(urlString: photoUrl, tempImage: "unavailable")
                } else {
                    Image(photoUrl, bundle: interfaceBundle)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .frame(width: frame.width, height: frame.height)
            .cornerRadius(5)
            
            Button(action: {
                withAnimation {
                    self.photoUrl = ""
                    self.didClose?()
                }
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
        }
    }
}

//struct ImageWithCloseBtn_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageWithCloseBtn()
//    }
//}
