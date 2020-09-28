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
        
        assignCancellable = Timer.publish(every: 1.0, on: .main, in: .default)
                    .autoconnect()
                    .map { String(describing: $0) }
                    .assign(to: \CountTimeModel.displayText, on: self)
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
