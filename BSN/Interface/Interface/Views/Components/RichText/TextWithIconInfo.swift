//
//  TextWithIconInfo.swift
//  Interface
//
//  Created by Phucnh on 10/8/20.
//

import SwiftUI

struct TextWithIconInfo: View {
    
    var icon: String
    
    var title: String
    
    var content: String
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(._primary)
                Text(title)
            }
            
            Text(content)
                .robotoLight(size: 13)
        }
        .padding(.vertical, 5)
    }
}

struct TextWithIconInfo_Previews: PreviewProvider {
    static var previews: some View {
        TextWithIconInfo(icon: "mappin.and.ellipse", title: "Địa chỉ giao dịch", content: "KTX khu A, DHQG - Khu pho 6, Linh Trung, Thu Duc.")
    }
}
