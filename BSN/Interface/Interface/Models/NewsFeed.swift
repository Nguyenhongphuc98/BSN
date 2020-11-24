//
//  NewsFeed.swift
//  Interface
//
//  Created by Phucnh on 9/28/20.
//

import Foundation
import Business

class NewsFeed: ObservableObject, AppendUniqueAble {
    
    var id: String
    
    var owner: User
    
    var postTime: Date
    
    var category: Category
    
    var quote: String?
    
    @Published var content: String
    
    // url to photo
    var photo: String?
    
    var numHeart: Int
    
    var numBeakHeart: Int
    
    var numComment: Int
    
    init() {
        id = UUID().uuidString
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
    }
}
