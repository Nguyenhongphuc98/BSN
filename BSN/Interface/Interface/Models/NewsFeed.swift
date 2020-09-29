//
//  NewsFeed.swift
//  Interface
//
//  Created by Phucnh on 9/28/20.
//

import Foundation

enum PostCategory: String {
    case skill
    case politic
}

class NewsFeed: ObservableObject, Identifiable {
    
    var id: String
    
    var owner: User
    
    var postTime: Date
    
    var category: PostCategory
    
    var quote: String?
    
    @Published var content: String
    
    var photo: String?
    
    var numHeart: Int
    
    var numBeakHeart: Int
    
    var numComment: Int
    
    init() {
        id = UUID().uuidString
        owner = User()
        postTime = randomDate()
        category = .skill
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
}
