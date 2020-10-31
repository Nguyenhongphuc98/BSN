//
//  GoogleApiRequest.swift
//  Business
//
//  Created by Phucnh on 10/27/20.
//

import Foundation
import Combine
import SwiftyJSON

// Get book info from google apis

class GoogleApiRequest {
    
    private let baseURL: String
    
    static let shared: GoogleApiRequest = GoogleApiRequest()
    
    init() {
        baseURL = "https://www.googleapis.com/books/v1/volumes/?q=isbn:"
    }
    
    func getBookInfo(by isbn:String, publisher: PassthroughSubject<EBook, Never>) {
        let resourceURL = URL(string: baseURL + isbn)!
        
        let dataTask = URLSession.shared
            .dataTask(with: resourceURL) { data, _, _ in
                
                guard let jsonData = data else {
                    print("Data not valid")
                    return
                }
                
                do {
                    let json = JSON(jsonData)
                    let items = try json["items"].array
                    var book = EBook()
                    
                    if items != nil {
                        for item in items! {
                            let authorsT = item["volumeInfo"]["authors"].array
                            let authors = authorsT != nil ? authorsT! : ["Unknown"]
                            
                            book.title = item["volumeInfo"]["title"].stringValue
                            book.author = ""
                            book.description = item["volumeInfo"]["description"].stringValue
                            book.cover = item["volumeInfo"]["imageLinks"]["smallThumbnail"].stringValue
                            
                            for author in authors {
                                book.author += "\(author.stringValue)"
                            }
                        }
                        
                        publisher.send(book)
                    } else {
                        var b = EBook()
                        b.id = "undefine"
                        publisher.send(b)
                    }
                } catch {
                    
                }
            }
        
        dataTask.resume()
    }
}
