//
//  PersonalizeViewModel.swift
//  Interface
//
//  Created by Phucnh on 12/6/20.
//

import UserNotifications
import UIKit
import Business

public class PersonalizeViewModel: NetworkViewModel {
    
    public static var shared: PersonalizeViewModel = .init()
    
    private var usercategoryManager: UserCategoryManager
    private var accountManager: AccountManager
    
    var categories: [Category]
    @Published var chunks: [ArraySlice<Category>]
    
    var numSelected: Int {
        let c = categories.filter { $0.interested == true }
        return c.count
    }
    
    public var didUpdateUserCategories: (() -> Void)?
    
    override init() {
        self.categories = []
        self.chunks = []
        self.usercategoryManager = .init()
        self.accountManager = .init()
        
        super.init()
        observerCategories()
        observerUpdateCategories()
        //prepareData()
    }
    
    public func didClickupdate(isOnboard: Bool) {
        self.isLoading = true
        
        // Any where, we also update user categories
        let c = categories.filter { $0.interested == true }
        let eucs = c.map { $0.toUerCategory() }
        usercategoryManager.updateUsercategories(userCategories: eucs)

        if isOnboard {
            // save interested
            // update account is onboard
            // load data for 5 tab
            // switch to inapp

            let ea = AppManager.shared.currentAccount.buildUpdate(isOnboard: true)
            accountManager.updateAccount(account: ea)
        }
    }
    
    public func prepareData() {
        print("did prepare data personalize VM")
        isLoading = true
        self.categories = []
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
                            let model = Category(id: c.categoryID, name: c.categoryName!, interested: c.isInterested!)
                            self.categories.append(model)                            
                        }                        
                    }
                    
                    self.buildChunks()
                }
            }
            .store(in: &cancellables)
    }
    
    private func observerUpdateCategories() {
        usercategoryManager
            .updatePublisher
            .sink {[weak self] (statusCode) in

                guard let self = self else {
                    return
                }

                DispatchQueue.main.async {
                    self.isLoading = false
                    if statusCode == 200 {
                        self.didUpdateUserCategories?()
                        // This mean observer of try to select in onbopard
                        if AppManager.shared.currentAccount.isOnboard == false {
                            AppManager.shared.currentAccount.isOnboard = true
                            setupData()
                        } else {
                            // Reload newfeed because interest categories change
                            NewsFeedViewModel.shared.prepareData()
                        }
                                                
                    } else {
                        self.resourceInfo = .update_fail
                        self.showAlert = true
                    }
                }
            }
            .store(in: &cancellables)
    }
}

// When user login first time or login other account
// We reset data and setup for push notifications
public func setupData() {
    
    setupNotifications()
    
    // Reload data for new user
    ChatViewModel.shared.prepareData()
    NotifyViewModel.shared.prepareData()
    ProfileViewModel.shared.forceRefeshData()
    ExploreBookViewModel.shared.prepareData()
    NewsFeedViewModel.shared.prepareData()
}

public func setupNotifications() {
    // Register push notifications
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
      print("Granted notifications?", granted)
      DispatchQueue.main.async {
        UIApplication.shared.registerForRemoteNotifications()
      }
    }
}
