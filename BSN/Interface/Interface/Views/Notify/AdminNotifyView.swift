//
//  AdminNotifyView.swift
//  Interface
//
//  Created by Phucnh on 1/26/21.
//

import SwiftUI

struct AdminNotifyView: View {
    
    @EnvironmentObject var notify: Notify
    
    var body: some View {
        VStack {
            
            Image("appIcon", bundle: interfaceBundle)
                .resizable()
                .frame(width: 80, height: 80)
                .padding()
                .padding(.top, 50)
            
            Text(notify.title!)
                .pattaya(size: 18)
                .padding()
            
            Text(notify.content!)
                .robotoLightItalic(size: 13)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
    }
}

struct AdminNotifyView_Previews: PreviewProvider {
    static var previews: some View {
        AdminNotifyView()
    }
}
