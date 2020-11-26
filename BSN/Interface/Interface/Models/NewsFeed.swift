//
//  NewsFeed.swift
//  Interface
//
//  Created by Phucnh on 9/28/20.
//

import Foundation
import Business

enum ReactType: Int {
    case heart = 0
    case unHeart
    case bHeart
    case unBHeart
}

class NewsFeed: ObservableObject, AppendUniqueAble {
    
    var id: String
    var owner: User
    var postTime: Date
    var category: Category
    var quote: String?
    var photo: String? // url to photo
    @Published var numHeart: Int
    @Published var numBeakHeart: Int
    @Published var numComment: Int
    
    @Published var content: String
    
    // Action bar
    @Published var activeHeart: Bool = false
    @Published var activeBHeart: Bool = false
    @Published var activeComment: Bool = false
    
    // reaction manager
    private var reactManager: ReactionManager = ReactionManager.shared
    
    init() {
        id = kUndefine
        owner = User()
        postTime = fakedates.randomElement()!
        category = Category(id: UUID().uuidString, name: "Category")
        content = "Một cuốn sách với mình khá hay. Mình đã phải ngạc nhiên trước kho kiến thức khổng lồ và chi tiết có trong sách. Đặc biệt là kiến thức về sự phát triển của Ai Cập mấy nghìn năm về trước. Mặc dù là sách về tôn giáo, tâm linh nhưng tác giả đã dùng từ ngữ rất dễ hiểu. Làm mình rất hứng thú mỗi khi đọc. Rất cảm ơn tác giả đã viết ra cuốn sách hay và ý nghĩa như vậy. Một câu mình rất thích là \"Nhân quả đừng đợi thấy mới tin\""
        
        let r = Int.random(in: 1...2)
        if r == 1 {
            quote = "Nhân quả đừng đợi thấy mới tin."
        } else {
            photo = "news1"
        }
        
        numHeart = 89
        numBeakHeart = 12
        numComment = 5
    }

    init(post: EPost) {
        id = post.id!
        owner = User(id: post.authorID, photo: post.authorPhoto, name: post.authorName!)
        postTime = Date.getDate(dateStr: post.createdAt)
        category = Category(id: post.categoryID, name: post.categoryName!)
        
        content = post.content
        quote = post.quote
        photo = post.photo
        
        numHeart = post.numHeart!
        numBeakHeart = post.numBreakHeart!
        numComment = post.numComment!
        
        if let react = post.isHeart {
            activeHeart = react
            activeBHeart = !react
        }
    }
    
    func clone(from news: NewsFeed) {
        id = news.id
        owner = news.owner
        postTime = news.postTime
        category = news.category
        
        content = news.content
        quote = news.quote
        photo = news.photo
        
        numHeart = news.numHeart
        numBeakHeart = news.numBeakHeart
        numComment = news.numComment
        
        activeHeart = news.activeHeart
        activeComment = news.activeComment
        activeBHeart = news.activeBHeart
    }
}

// MARK: - Reaction
extension NewsFeed {
    func processReact(action: ReactType) {
        
        // Recaculate num heart and num bheart
        switch action {
        case .heart:
            self.numHeart += 1
            self.numBeakHeart -= self.activeBHeart ? 1 : 0
        case .unHeart:
            self.numHeart -= 1
        case .bHeart:
            self.numBeakHeart += 1
            self.numHeart -= self.activeHeart ? 1 : 0
        case .unBHeart:
            self.numBeakHeart -= 1
        }
        
        // Hight light UI and request to BL
        switch action {
        case .heart, .bHeart:
            let r = EReaction(
                userID: AppManager.shared.currenUID,
                postID: self.id,
                isHeart: action == .heart
            )
            // make sure other reac not same state
            self.activeHeart = action == .heart
            self.activeBHeart = action == .bHeart
            
            reactManager.makeReact(reaction: r)
            
        case .unHeart, .unBHeart:
            // make sure other reac not same state
            self.activeHeart = (action == .unHeart) ? false : self.activeHeart
            self.activeBHeart = (action == .unBHeart) ? false : self.activeBHeart
            
            reactManager.unReact(uid: AppManager.shared.currenUID, pid: self.id)
        }
        
        self.objectWillChange.send()
    }
}
