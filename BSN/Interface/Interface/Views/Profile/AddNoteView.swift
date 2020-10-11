//
//  AddNoteView.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI

struct AddNoteView: View {
    
    @EnvironmentObject var viewModel: MyBookDetailViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var noteContent: String = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 20) {
                Text("Thêm bài học")
                    .robotoBold(size: 18)
                
                EditorWithPlaceHolder(text: $noteContent, placeHolder: "Để lại bài học của bạn tại đây")
                    .frame(height: 100)
                    .cornerRadius(5)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    viewModel.addNewNote(content: noteContent, complete: { (success) in
                        print("did process: \(noteContent) - \(success)")
                        presentationMode.wrappedValue.dismiss()
                    })
                    
                }, label: {
                    Text("   Lưu bài học   ")
                })
                .buttonStyle(BaseButtonStyle(size: .large))
                
                Spacer()
            }
            .padding()
            
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Huỷ")
                        .padding()
                })
                
                Spacer()
            }
        }
        .background(Color(.secondarySystemBackground))
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
    }
}
