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
            .aspectRatio(contentMode: .fit)
            .onAppear(perform: viewAppeared)
    }
    
    func viewAppeared() {
        loader.setup(urlString: urlString, temp: "loading")
    }
}

//struct BSNImage_Previews: PreviewProvider {
//    static var previews: some View {
//        BSNImage()
//    }
//}
