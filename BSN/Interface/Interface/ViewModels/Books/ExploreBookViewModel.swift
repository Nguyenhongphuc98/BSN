//
//  SearchViewViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/5/20.
//

import SwiftUI
import Business

public class ExploreBookViewModel: SearchBookViewModel {
    
    public static var shared: ExploreBookViewModel = ExploreBookViewModel()
    
    @Published var suggestBooks: [BSusggestBook]
    @Published var exchangeBooks: [BExchangeBook]
    
    private var ebManager: ExchangeBookManager
    private var bookManager: BookManager
    
    public override init() {
        suggestBooks = []
        exchangeBooks = []
        ebManager = ExchangeBookManager()
        bookManager = BookManager()
        super.init()
        
        setupReceiveEBs()
        setupReceiveTopBooks()
        prepareData()
    }
    
    public func prepareData() {
        print("did prepare data explore book VM")
        // load favorite book
        // load page 0 exchange book
        self.exchangeBooks = []
        self.suggestBooks = []
        loadExchangeBooks()
        loadTopBooks(categoryID: "", page: 1) // using defaul paginate so it begin with 1 index
    }
    
    func loadExchangeBooks() {
        // defaul just load page 0
        self.exchangeBooks = []
        ebManager.getNewestExchangeBooks(page: 0)
    }
    
    func reloadTopBooks(categoryID: String = "") {
        // defaul just load page 1 - defaul
        self.suggestBooks = []
        loadTopBooks(categoryID: categoryID, page: 1)
    }
    
    func loadTopBooks(categoryID: String, page: Int) {
        bookManager.fetchTopBooks(categoryID: categoryID, page: page)
    }
    
    private func setupReceiveEBs() {
        ebManager
            .getExchangeBooksPublisher
            .sink {[weak self] (ebs) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if !ebs.isEmpty {
                        ebs.forEach { (eb) in
                            let model = BExchangeBook(
                                id: eb.id,
                                firstTitle: eb.firstTitle!,
                                firstAuthor: eb.firstAuthor!,
                                firstCover: eb.firstCover!,
                                partnerLocation: eb.location!,
                                sencondTitle: eb.secondTitle!,
                                secondAuthor: eb.secondAuthor!
                            )
                            self.exchangeBooks.appendUnique(item: model)
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func removeEB(ebid: String) {
        exchangeBooks.removeAll { $0.id == ebid }
    }
    
    private func setupReceiveTopBooks() {
        /// Get save user_book
        bookManager
            .getBooksPublisher
            .sink {[weak self] (bs) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if !bs.isEmpty {
                        bs.forEach { (b) in
                            let model = BSusggestBook(
                                id: b.id!,
                                title: b.title,
                                author: b.author,
                                cover: b.cover,
                                avgRating: b.avgRating!,
                                numReview: b.numReview!
                            )
                            withAnimation {
                                self.suggestBooks.appendUnique(item: model)
                            }                            
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}
