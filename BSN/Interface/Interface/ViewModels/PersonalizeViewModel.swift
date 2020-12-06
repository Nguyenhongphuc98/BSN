//
//  PersonalizeViewModel.swift
//  Interface
//
//  Created by Phucnh on 12/6/20.
//

import Business

public class PersonalizeViewModel: NetworkViewModel {
    
    public static var shared: PersonalizeViewModel = .init()
    
    private var usercategoryManager: UserCategoryManager
    
    var categories: [Category]
    @Published var chunks: [ArraySlice<Category>]
    
    var numSelected: Int {
        let c = categories.filter { $0.interested == true }
        return c.count
    }
    
    override init() {
        self.categories = []
        self.chunks = []
        self.usercategoryManager = .init()
        
        super.init()
        observerCategories()
        prepareData()
    }
    
    public func didClickupdate(isOnboard: Bool) {
        self.isLoading = true
        if AppManager.shared.currentAccount.isOnboard {
            // save interested
            // update account is onboard
            // load data for 5 tab
            // switch to inapp
        } else {
            // update interest and reload newfeed
        }
    }
    
    public func prepareData() {
        print("did prepare data personalize VM")
        isLoading = true
        usercategoryManager.getCategoriesBy(uid: AppManager.shared.currenUID)
    }
    
    private func buildChunks() {
        chunks = [[]]
        let maxLength = 25
        var length = 0
        var chunkIndex = 0
        categories.forEach { (category) in
            if length + category.name.count > maxLength {
                length = 0
                chunkIndex += 1
                chunks.append([])
                //print(">>>***")
            }
            
            length += category.name.count
            chunks[chunkIndex].append(category)
            //print(category.name)
            //print(length)
        }
        self.objectWillChange.send()
    }
    
    private func observerCategories() {
        usercategoryManager
            .categoriesPublisher
            .sink {[weak self] (categories) in

                guard let self = self else {
                    return
                }

                DispatchQueue.main.async {
                    self.isLoading = false
                    self.categories = []
                    categories.forEach { (c) in
                        if c.categoryName != "Không xác định" {
                            let model = Category(id: c.categoryID, name: c.categoryName, interested: c.isInterested)
                            self.categories.append(model)                            
                        }                        
                    }
                    
                    self.buildChunks()
                }
            }
            .store(in: &cancellables)
    }
}
