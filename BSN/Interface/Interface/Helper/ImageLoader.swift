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
    
    // Image will be set if err to got image grom url
    private var instate: String
    
    // Caching fetched images
    public static var imageCache = AutoPurgingImageCache()
    
    public init() {
        uiImage = UIImage(named: "loading", in: interfaceBundle, with: nil)!
        instate = "loading"
    }
    
    public func setup(urlString: String?, temp: String) {
        if self.urlString != urlString {
            self.instate = temp
            self.urlString = urlString
            download(urlString: urlString)
        }
    }

    private func download(urlString: String?) {
        guard let url = URL(string: urlString!) else {
            self.uiImage = UIImage(named: self.instate, in: interfaceBundle, with: nil)!
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
            } else {
                self.uiImage = UIImage(named: self.instate, in: interfaceBundle, with: nil)!
            }
        })
    }
}
