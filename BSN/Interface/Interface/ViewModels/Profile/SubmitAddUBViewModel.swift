//
//  SubmitAddBookViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI
import Business
import Combine

class SubmitAddUBViewModel: ObservableObject {
    
    @Published var model: BUserBook
    
    @Published var isbn: String
    
    @Published var showAlert: Bool
    
    @Published var enableDoneBtn: Bool
    
    @Published var isLoading: Bool
    
    @Published var bState: BookState
    
    @Published var bStatus: BookStatus
    
    private var bookManager: BookManager
    
    private var userBookManager: UserBookManager
    
    private var bookID: String?
    
    // Handle result process resource
    var resourceInfo: ResourceInfo
    
    //Cancellable
    var cancellables = Set<AnyCancellable>()
    
    init() {
        model = BUserBook()
        isbn = ""
        bookManager = BookManager.shared
        userBookManager = UserBookManager.shared
        showAlert = false
        enableDoneBtn = false
        isLoading = false
        resourceInfo = .success
        bState = .available
        bStatus = .new
        
        setupReceiveBookInfo()
        setupReceiveSaveBookInfo()
        setupReceiveGoogleBookInfo()
        setupReceiveSaveUserBookInfo()
    }
    
    /// Fetching data from Server to fill page if it passed bookID from preView
    func prepareData(bookID: String) {
        self.bookID = bookID
        self.isLoading = true
        bookManager.fetchBook(bookID: bookID)
    }
    
    /// Fetching book info from google base on isbn
    func loadInfoFromGoogle() {
        self.isLoading = true
        bookManager.getBookInfo(by: isbn)
    }
    
    /// Add new book to book system
    private func addBook() {
        let newBook = EBook(
            title: model.title,
            author: model.author,
            isbn: isbn,
            cover: model.cover,
            des: model.description
        )
        
        bookManager.saveBook(book: newBook)
    }
    
    /// Perform get book by isbn
    func addUserBook() {
        /// After receive book in fo it will auto save userbook
        isLoading = true
        bookManager.fetchBook(isbn: isbn)
    }
    
    /// Book get from server or google will received at this block
    private func setupReceiveBookInfo() {
        /// Get book by ID to load on UI
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
                        
                        self.isbn = book.isbn
                        self.model.title = book.title
                        self.model.author = book.author
                        self.model.description = book.description!
                        self.model.cover = book.cover ?? "book_cover"
                        self.enableDoneBtn = true
                        print("did receive book info")
                    }
                }
            }
            .store(in: &cancellables)
       
        /// Get book by isbn to save new UserBook
        bookManager
            .getBookByIsbnPublisher
            .sink { [weak self] book in
                guard let self = self else {
                    return
                }
                
                /// When receive info of book, save user book to server
                let userBook = EUserBook(
                    uid: AppManager.shared.currentUser.id,
                    bid: book.id,
                    status: self.bStatus.rawValue,
                    state: self.bState.rawValue,
                    statusDes: self.model.statusDes,
                    title: book.title,
                    author: book.author
                )
                
                self.userBookManager.saveUserBook(ub: userBook)
            }
            .store(in: &cancellables)
    }
    
    /// Result book info from google api
    private func setupReceiveGoogleBookInfo() {
        bookManager
            .getGoogleBookPublisher
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
                        /// No need to show notify
                        //self.resourceInfo = .success
                        
                        // Data showing is enought
                        self.model.title = book.title
                        self.model.author = book.author
                        self.model.description = book.description!
                        self.model.cover = book.cover ?? "book_cover"
                        self.enableDoneBtn = true
                        
                        // Add new book to server if it don't exists
                        self.addBook()
                    }
                    
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupReceiveSaveBookInfo() {
        bookManager
            .saveBookPublisher
            .sink {[weak self] (book) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    
                    // It should working in slient, if error, user don't need to know
                    //=====================
//                    if book.id == "undefine" {
//                        self.resourceInfo = .exists
//                    } else {
//                        self.resourceInfo = .success
//                    }
                    //self.showAlert.toggle()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupReceiveSaveUserBookInfo() {
        /// Get save user_book
        userBookManager
            .changePublisher
            .sink {[weak self] (ub) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    self.resourceInfo = (ub.id == "undefine") ? .savefailure : .success
                    self.showAlert.toggle()
                }
            }
            .store(in: &cancellables)
    }
}
