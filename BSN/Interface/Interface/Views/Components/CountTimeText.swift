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
        self.displayText = "5 seconds"
        
//        assignCancellable = Timer.publish(every: 1.0, on: .main, in: .default)
//                    .autoconnect()
//                    .map { String(describing: $0) }
//                    .assign(to: \CountTimeModel.displayText, on: self)
        
//        print("delta \(date.timeIntervalSinceNow.stringTime)")
        caculateDisplay()
    }
    
    func caculateDisplay() {
        let interval = date.timeIntervalSinceNow
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        if interval.days > 7 {
            displayText = formatter.string(from: date)
        } else if interval.days != 0 {
            displayText = "\(interval.days) ngày trước"
        } else if interval.hours != 0 {
            displayText = "\(interval.hours) giờ trước"
        } else if interval.minutes != 0 {
            displayText = "\(interval.minutes) phút trước"
        } else if interval.days != 0 {
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
