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
    
    func getBookInfo(by isbn:String, publisher: PassthroughSubject<Book, Never>) {
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
                    var book = Book()
                    
                    if items != nil {
                        for item in items! {
                            let authors = item["volumeInfo"]["authors"].array!
                            
                            book.title = item["volumeInfo"]["title"].stringValue
                            book.author = ""
                            book.title = item["volumeInfo"]["title"].stringValue
                            book.description = item["volumeInfo"]["description"].stringValue
                            book.cover = item["volumeInfo"]["imageLinks"]["smallThumbnail"].stringValue
                            
                            for author in authors {
                                book.author += "\(author.stringValue)"
                            }
                        }
                        
                        publisher.send(book)
                    } else {
                        var b = Book()
                        b.id = "undefine"
                        publisher.send(b)
                    }
                } catch {
                    
                }
            }
        
        dataTask.resume()
    }
}
