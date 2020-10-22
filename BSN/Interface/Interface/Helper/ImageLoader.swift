//
//  ImageLoader.swift
//  Interface
//
//  Created by Phucnh on 10/21/20.
//

import AlamofireImage

public class ImageLoader: ObservableObject {
    // Download image from url
    
    // url to image need to download
    private var urlString: String?
    
    // UIImage got from url
    @Published var uiImage: UIImage
    
    // Caching fetched images
    public static var imageCache = AutoPurgingImageCache()
    
    public init() {
        uiImage = UIImage(named: "loading", in: interfaceBundle, with: nil)!
    }
    
    public func setup(urlString: String, temp: String) {
        if self.urlString == nil {
            self.urlString = urlString
            uiImage = UIImage(named: temp, in: interfaceBundle, with: nil)!
            download(urlString: urlString)
        }
    }

    private func download(urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let imageDownloader = ImageDownloader(
            configuration: ImageDownloader.defaultURLSessionConfiguration(),
            downloadPrioritization: .fifo,
            maximumActiveDownloads: 5,
            imageCache: ImageLoader.imageCache
        )
        
        imageDownloader.download(urlRequest, completion:  { response in
            if case .success(let image) = response.result {
                self.uiImage = image
            }
        })
    }
}
