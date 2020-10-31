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
                
                Button(action: { viewModel.addNewNote(content: noteContent) }, label: {
                    Text("   Lưu bài học   ")
                })
                .buttonStyle(BaseButtonStyle(size: .large))
                
                Spacer()
            }
            .padding()
            
            HStack {
                Button(action: { dissmiss() }, label: {
                    Text("Huỷ").padding()
                })
                
                Spacer()
            }
        }
        .background(Color(.secondarySystemBackground))
        .embededLoading(isLoading: $viewModel.isLoading)
        .alert(isPresented: $viewModel.showAlert, content: alert)
    }
    
    func alert() -> Alert {
        if viewModel.resourceInfo == .success {
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                dismissButton: .default(Text("OK")) {
                    dissmiss()
                })
        } else {
            
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                primaryButton: .default(Text("Thử lại")) {
                    viewModel.addNewNote(content: noteContent)
                },
                secondaryButton: .cancel(Text("Huỷ bỏ")) {
                    dissmiss()
                })
        }
    }
    
    private func dissmiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
    }
}
