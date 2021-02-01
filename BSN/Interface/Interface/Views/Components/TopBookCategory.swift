//
//  TopBookCategory.swift
//  Interface
//
//  Created by Phucnh on 2/1/21.
//

import SwiftUI

// Component to show list category
// Should use in top favorite book
struct TopBookCategory: View {
    
    @State private var isCollapse: Bool = true
    @State private var focusCategory: Category = Category(id: kUndefine, name: "Tất cả")
    
    @StateObject var viewModel: CategoryViewModel = .shared
    
    var didSelect: ((String) -> Void) // id
    var body: some View {
        HStack {
            if !isCollapse {
                Menu {
                    ForEach(viewModel.categories) { c in
                        Button {
                            focusCategory = c
                            didSelect(c.id)
                        } label: {
                            Text(c.name)
                        }
                    }
                    Button {
                        focusCategory = Category(id: kUndefine, name: "Tất cả")
                        didSelect(kUndefine)
                    } label: {
                        Text("Tất cả")
                    }
                } label: {
                    Text(focusCategory.name)
                        .foregroundColor(.white)
                }
            }
            
//            Button {
//
//            } label: {
                Image(systemName: isCollapse ? "chevron.forward" : "chevron.backward")
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .background(Color.init(hex: 0xA6B2E3))
                    .clipShape(Circle())
                    .onTapGesture {
                        withAnimation {
                            self.isCollapse.toggle()
                        }
                    }
//            }
//            .buttonStyle(PlainButtonStyle())
        }
        .padding(7)
        .background(Color.init(hex: 0xBB44EE))
        .cornerRadius(20, corners: [.bottomRight, .topRight])
    }
}
