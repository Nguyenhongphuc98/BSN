//
//  BSNImage.swift
//  Interface
//
//  Created by Phucnh on 10/21/20.
//

import SwiftUI

struct BSNImage: View {
    // Image with auto download data from url
    
    var urlString: String?
    
    var tempImage: String = "loading"
    
    @StateObject var loader: ImageLoader = ImageLoader()
    
    var body: some View {
        Image(uiImage: loader.uiImage)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .onReload {
                refetchImage()
            }
            //.onAppear(perform: viewAppeared)
    }
    
    func refetchImage() {
        loader.setup(urlString: urlString, temp: tempImage)
    }
    
    func getUIImage() -> UIImage {
        loader.uiImage
    }
}

//struct BSNImage_Previews: PreviewProvider {
//    static var previews: some View {
//        BSNImage()
//    }
//}
