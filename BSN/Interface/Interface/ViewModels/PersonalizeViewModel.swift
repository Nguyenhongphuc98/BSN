//
//  PersonalizeViewModel.swift
//  Interface
//
//  Created by Phucnh on 12/6/20.
//

import Business

public class PersonalizeViewModel: NetworkViewModel {
    
    public static var shared: PersonalizeViewModel = .init()
    
    //private var notifyManager: NotifyManager
    
    var categories: [Category]
    @Published var chunks: [ArraySlice<Category>]
    
    override init() {
        categories = [Category(id: UUID().uuidString, name: "Kỹ năng"),
                      Category(id: UUID().uuidString, name: "Mẹ và bé"),
                      Category(id: UUID().uuidString, name: "Chính trị - Pháp luật"),
                      Category(id: UUID().uuidString, name: "Công nghệ"),
                      Category(id: UUID().uuidString, name: "Giáo khoa - Giáo trình"),
                      Category(id: UUID().uuidString, name: "Học ngoại ngữ"),
                      Category(id: UUID().uuidString, name: "Khoa học - Kỹ thuật"),
                      Category(id: UUID().uuidString, name: "Kiến thức tổng hợp"),
                      Category(id: UUID().uuidString, name: "Lịch sử"),
                      Category(id: UUID().uuidString, name: "Nông lâm - Ngư nghiệp"),
                      Category(id: UUID().uuidString, name: "Tham khảo"),
                      Category(id: UUID().uuidString, name: "Gia đình"),
                      Category(id: UUID().uuidString, name: "Tâm lý - Giới tính"),
                      Category(id: UUID().uuidString, name: "Tôn giáo - Tâm linh"),
                      Category(id: UUID().uuidString, name: "Văn hoá - Du lịch"),
                      Category(id: UUID().uuidString, name: "Y học"),
                      Category(id: UUID().uuidString, name: "Kinh tế"),
                      Category(id: UUID().uuidString, name: "Thiếu nhi"),
                      Category(id: UUID().uuidString, name: "Văn học"),
                      Category(id: UUID().uuidString, name: "Thể dục - Thể thao"),
                      Category(id: UUID().uuidString, name: "Truyện")]
        self.chunks = []
        
        super.init()
        //observerCategories()
        buildChunks()
    }
    
    public func prepareData() {
        print("did prepare data personalize VM")
        isLoading = true
        
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
                print(">>>***")
            }
            
            length += category.name.count
            chunks[chunkIndex].append(category)
            print(category.name)
            print(length)
        }
    }
    
    private func observerCategories() {
//        notifyManager
//            .receiveNotifyPublisher
//            .sink {[weak self] (n) in
//
//                guard let self = self else {
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    let notify = Notify(enotify: n)
//                    self.notifies.insertUnique(item: notify)
//                }
//            }
//            .store(in: &cancellables)
    }
}
