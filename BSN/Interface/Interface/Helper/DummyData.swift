//
//  DummyData.swift
//  Interface
//
//  Created by Phucnh on 9/28/20.
//

import Foundation

// MARK: - Support info
class Format {
    
    let formatter: DateFormatter
    
    init() {
        formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    }
    
    func date(date: String) -> Date {
        let date = formatter.date(from: date)!
        print("\(formatter.string(from: date)) : \(date.timeIntervalSinceNow.stringTime)")
        return date
    }
}


// MARK: - main dummy data

let fm = Format()
let dates = [
    //fm.date(date: "2016/10/08 22:31"),
    //fm.date(date: "2020/09/25 22:31"),
    fm.date(date: "2020/09/28 15:40:00"),
    fm.date(date: "2020/09/28 15:47:00"),
    Date()]
func randomDate() -> Date {
    let date = dates[Int.random(in: 0...2)]
    //let formatter = DateFormatter()
    //formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    //print("\(formatter.string(from: date)) : \(date.timeIntervalSinceNow.stringTime)")
    return date
}

let fakeNews = [NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed(), NewsFeed()]

let fakeCategories = ["Unknown", "Kỹ năng", "Truyện tranh", "Giáo trình", "Chính trị"]

let fakeComments = ["đoạn nhân vật chính gây nghiệp ác nên đầu thai thành hàng triệu con côn trùng làm mình bật cười, nhưng dù sao đây cũng là 1 lý thuyết đáng chú ý",
                    "Đây là một quyển sách mà ai cũng nên đọc, đọc để hiểu quy luật luân hồi và bài học nhân sinh. Hiểu ra được nhiều điều và áp dụng cho biến chuyển trong đời sống ngày hôm nay",
                    "Quyển sách hay nhất sau Hành trình về phương Đông ở khía cạnh cuộc sống, ý nghĩa cuộc đời, đan xen bí ẩn và hành trình gây kinh ngạc qua các kiếp sống. ",
                    "Gập cuốn sách lại với một niềm xúc động vô bờ. Dòng chữ: “Tôi quyết định viết cuốn sách này bằng tiếng Việt - ngôn ngữ đồng bào, đất nước thân thương trong trái tim tôi” của bác Nguyên Phong khiến mình tự hào ghê gớm",
                    "Sách của bác chưa bao giờ làm mình thất vọng, cuốn nào cũng đầy sự minh triết, trí tuệ dạt dào. “Muôn kiếp nhân sinh” xuất bản thật đúng thời điểm. Nó như cơn mưa rào trong nắng hạn, giúp giải tỏa cơn khát cho những ai còn đang trôi lăn, lặn ngụp trong vòng xoáy hỗn loạn của tiền tài và danh vọng mà chưa tìm ra mục đích lớn lao nhất của cuộc đời mình là gì."]

func randomComment() -> String {
    let comment = fakeComments[Int.random(in: 0...4)]
    return comment
}

let fakeNames = ["Nguyễn Thiên Kim", "Võ Văn thắng", "Mai Chí Thọ", "Ngân Nguyễn", "Hồng Phúc"]

func randomName() -> String {
    let name = fakeNames[Int.random(in: 0...4)]
    return name
}

let fakeAvatars = ["avatar", "avatar2", "avatar3", "avatar4"]

func randomAvatar() -> String {
    let avatar = fakeAvatars[Int.random(in: 0...3)]
    return avatar
}
