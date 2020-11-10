//
//  SearchBar.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var isfocus: Bool
    
    @Binding var searchText: String
    
    var onchange: (() -> Void)?
    
    //var oncancel: (() -> Void)?
    
    var body: some View {
        HStack {
            // Text search content
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("search", text: $searchText, onEditingChanged: { isEditing in
                    withAnimation {
                        self.isfocus = true
                    }
                }, onCommit: {
                    print("onCommit")
                })
                .foregroundColor(.primary)
                
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            
            // Cancel button
            if isfocus  {
                Button("Huỷ") {
                    UIApplication.shared.endEditing(true) // this must be placed before the other commands here
                    withAnimation {
                        self.searchText = ""
                        self.isfocus = false
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

//struct SearchBar_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBar(searchText: <#T##Binding<String>#>)
//    }
//}
