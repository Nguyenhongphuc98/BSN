//
//  CountTimeText.swift
//  Interface
//
//  Created by Phucnh on 9/28/20.
//

import SwiftUI
import Combine

class CountTimeModel: ObservableObject {
    
    var date: Date
    
    @Published var displayText: String
    
    private var assignCancellable: AnyCancellable? = nil
    
    init(date: Date) {
        self.date = date
        self.displayText = "caculating"
        caculateDisplay()
    }
    
    func caculateDisplay() {
        let interval = -date.timeIntervalSinceNow
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        //print("interval: \(interval)")
        //print("date: \(formatter.string(from: date))")
        //print("now: \(formatter.string(from: Date()))")
        
        if interval.days > 7 {
            displayText = formatter.string(from: date)
        } else if interval.days != 0 {
            displayText = "\(interval.days) ngày trước"
        } else if interval.hours != 0 {
            displayText = "\(interval.hours) giờ trước"
        } else if interval.minutes != 0 {
            displayText = "\(interval.minutes) phút trước"
        } else {
            displayText = "vừa xong"
        }
    }
}

struct CountTimeText: View {
    
    private var model: CountTimeModel
    
    init(date: Date) {
        model = CountTimeModel(date: date)
    }
    
    var body: some View {
        Text(model.displayText)
            .font(.custom("Roboto-Bold", size: 9))
            .foregroundColor(Color.init(hex: 0x6D6D6D))
    }
}

struct CountTimeText_Previews: PreviewProvider {
    static var previews: some View {
        CountTimeText(date: Date())
    }
}
