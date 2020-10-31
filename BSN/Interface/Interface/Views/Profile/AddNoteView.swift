//
//  AddNoteView.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI

struct AddNoteView: View {
    
    @EnvironmentObject var viewModel: MyBookDetailViewModel
    
    /// Note `undefine` mean add new, else update
    @EnvironmentObject private var passthroughtNote: Note
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 20) {
                Text("Thêm bài học")
                    .robotoBold(size: 18)
                
                EditorWithPlaceHolder(text: $passthroughtNote.content, placeHolder: "Để lại bài học của bạn tại đây")
                    .frame(height: 100)
                    .cornerRadius(5)
                    .padding()
                
                Spacer()
                
                Button(action: { viewModel.processNote(note: passthroughtNote) }, label: {
                    Text("   \(passthroughtNote.isUndefine() ? "Lưu" : "Cập nhật") bài học   ")
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
                    viewModel.processNote(note: passthroughtNote)
                },
                secondaryButton: .cancel(Text("Huỷ bỏ")) {
                    dissmiss()
                })
        }
    }
    
    private func dissmiss() {
        passthroughtNote.reset()
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
    }
}
