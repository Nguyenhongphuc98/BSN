////
////  BSNImage.swift
////  Interface
////
////  Created by Phucnh on 10/21/20.
////
//
//// Image with auto download data from url
//import SwiftUI
//
//class ImageLoader: ObserableObject {
//    
////    var url: String
////
////    var temp: String
//    
//    //@Pub var uiImage: UIImage
//    
//    init(urlString: String, temp: String) {
////        self.url = url
////        self.temp = temp
//        
//        uiImage = UIImage(named: self.imageName, bu)
//        download()
//    }
//    
//    func download() {
//        guard let url = URL(string: urlString) else {
//            return
//        }
//        
//        let urlRequest = URLRequest(url: url)
//        
//        let imageDownloader = ImageDownloader(
//            configuration: ImageDownloader.defaultURLSessionConfiguration(),
//            downloadPrioritization: .fifo,
//            maximumActiveDownloads: 4,
//            imageCache: ImageLoader.imageCache
//        )
//        
//        imageDownloader.download(urlRequest) { response in
//            if case .success(let image) = response.result {
//                self.data = image
//            }
//        }
//    }
//}
//
//struct BSNImage: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct BSNImage_Previews: PreviewProvider {
//    static var previews: some View {
//        BSNImage()
//    }
//}
