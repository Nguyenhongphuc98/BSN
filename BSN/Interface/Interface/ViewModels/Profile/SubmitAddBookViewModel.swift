//
//  SubmitAddBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI
import Business
import Combine

class SubmitAddBookViewModel: ObservableObject {
    
    @Published var model: BUserBook
    
    @Published var isbn: String
    
    @Published var showAlert: Bool
    
    @Published var enableDoneBtn: Bool
    
    @Published var isLoading: Bool
    
    private var bookManager: BookManager
    
    private var bookID: String?
    
    // Handle reslut process resource
    var resourceInfo: ResourceInfo
    
    //Cancellable
    var searchCancellables = Set<AnyCancellable>()
    
    init() {
        model = BUserBook()
        isbn = ""
        bookManager = BookManager.shared
        showAlert = false
        enableDoneBtn = false
        isLoading = false
        resourceInfo = .success
        
        setupReceiveBookInfo()
        setupReceiveSaveBookInfo()
        setupReceiveGoogleBookInfo()
    }
    
    func prepareData(bookID: String) {
        self.bookID = bookID
        self.isLoading = true
        bookManager.fetchBook(bookID: bookID)
    }
    
    func loadInfoFromGoogle() {
        self.isLoading = true
        bookManager.getBookInfo(by: isbn)
    }
    
    /// Add new book to book system
    func addBook() {
        let newBook = Book(
            title: model.title,
            author: model.author,
            isbn: isbn,
            cover: model.cover,
            des: model.description
        )
        
        bookManager.saveBook(book: newBook)
    }
    
    func addUserBook(complete: @escaping (Bool) -> Void) {
        complete(true)
    }
    
    func updateUserBook(complete: @escaping (Bool) -> Void) {
        complete(true)
    }
    
    /// Result book info from google api
    /// Book get from server or google will received at this block
    func setupReceiveBookInfo() {
        print("Begin setup get book info receive")
        bookManager
            .getBookPublisher
            .sink {[weak self] (book) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if book.id == "undefine" {
                        self.resourceInfo = .notfound
                        self.showAlert.toggle()
                    } else {
                        
                        self.model.title = book.title
                        self.model.author = book.author
                        self.model.description = book.description!
                        self.model.cover = book.cover
                        self.enableDoneBtn = true
                        print("did receive book info")
                    }
                }
            }
            .store(in: &searchCancellables)
        print("Finish setup get book info receive")
    }
    
    func setupReceiveGoogleBookInfo() {
        bookManager
            .getGoogleBookPublisher
            .sink {[weak self] (book) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.resourceInfo = .success
                    
                    self.model.title = book.title
                    self.model.author = book.author
                    self.model.description = book.description!
                    self.model.cover = book.cover
                    self.enableDoneBtn = true
                    
                    self.showAlert.toggle()
                    
                    self.addBook()
                }
            }
            .store(in: &searchCancellables)
    }
    
    func setupReceiveSaveBookInfo() {
        bookManager
            .saveBookPublisher
            .sink {[weak self] (book) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.showAlert.toggle()
                    
                    if book.id == "undefine" {
                        self.resourceInfo = .exists
                    } else {
                        self.resourceInfo = .success
                    }
                }
            }
            .store(in: &searchCancellables)
    }
}
