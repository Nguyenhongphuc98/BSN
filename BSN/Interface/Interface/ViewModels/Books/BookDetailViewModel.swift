//
//  BookDetailViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI
import Business

class BookDetailViewModel: NetworkViewModel {
    
    @Published var model: BBookDetail
    @Published var reviewed: Bool // mark that current user did review this book
    
    var reviews: [Rating]
    
    private var bookReviewManager: BookReviewManager
    private var bookManager: BookManager
    
    override init() {
        model = BBookDetail()
        reviewed = false
        reviews = []
        bookReviewManager = BookReviewManager()
        bookManager = BookManager()
        
        super.init()
        setupReceiveReivews()
        setupReceiveBook()
    }
    
    func prepareData(bid: String) {
        isLoading = true
        model.id = bid
        
        bookManager.fetchBook(bookID: bid)
        bookReviewManager.getReviews(bid: bid)
    }
    
    func reloadData() {
        // reload to change rating number
        bookManager.fetchBook(bookID: model.id!)
        // append new reviews
        self.reviews = []
        bookReviewManager.getReviews(bid: model.id!)
    }
    
    func deleteReview(rid: String) {
        bookReviewManager.deleteReview(reivewID: rid)
        withAnimation {
            reviews.removeAll { $0.id == rid }
            reviewed = false
            objectWillChange.send()
        }
        
        // Reload base info
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.bookManager.fetchBook(bookID: self.model.id!)
        }
    }
    
    func getReiviewOfcurrentUser() -> Rating? {
        return reviews.first { $0.authorID == AppManager.shared.currenUID }
    }
    
    private func setupReceiveBook() {
        bookManager
            .getBookPublisher
            .sink {[weak self] (b) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if b.id == kUndefine {
                        self.resourceInfo = .getfailure
                        self.showAlert = true
                    } else {
                        self.model = BBookDetail(book: b)
                        self.objectWillChange.send()
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupReceiveReivews() {
        bookReviewManager
            .getReviewsPublisher
            .sink {[weak self] (brs) in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if !brs.isEmpty {
                        brs.forEach { (br) in
                            let model = Rating(
                                id: br.id,
                                authorPhoto: br.avatar!,
                                authorID: br.userID!,
                                title: br.title,
                                character: br.characterRating ,
                                write: br.writeRating ,
                                target: br.targetRating ,
                                info: br.infoRating,
                                rating: br.avgRating,
                                content: br.description!,
                                bookID: br.bookID!,
                                createAt: br.createdAt
                            )
                            self.reviews.appendUnique(item: model)
                            if br.userID == AppManager.shared.currenUID {
                                self.reviewed = true
                            }
                        }
                        self.objectWillChange.send()
                    }
                }
            }
            .store(in: &cancellables)
    }
}
