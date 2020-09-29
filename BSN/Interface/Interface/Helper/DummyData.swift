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

let fakeCategory = ["Unknown", "Kỹ năng", "Truyện tranh", "Giáo trình", "Chính trị"]
