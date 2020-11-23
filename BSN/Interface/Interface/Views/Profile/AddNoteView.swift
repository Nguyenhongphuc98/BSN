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
    
    @State var message: String = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 20) {
                Text("\(passthroughtNote.isUndefine() ? "Thêm" : "Cập nhật") bài học")
                    .robotoBold(size: 18)
                
                EditorWithPlaceHolder(text: $message, placeHolder: "Để lại bài học của bạn tại đây")
                    .frame(height: 100)
                    .cornerRadius(5)
                    .padding()
                
                Spacer()
                
                Button(action: {
                    passthroughtNote.content = message
                    viewModel.processNote(note: passthroughtNote)
                },
                label: {
                    Text("   \(passthroughtNote.isUndefine() ? "Lưu" : "Cập nhật") bài học   ")
                })
                .buttonStyle(BaseButtonStyle(size: .large))
                
                Spacer()
            }
            .padding()
            
            HStack {
                Button(action: { dismiss() }, label: {
                    Text("Huỷ").padding()
                })
                
                Spacer()
            }
        }
        .background(Color(.secondarySystemBackground))
        .embededLoading(isLoading: $viewModel.isLoading)
        .alert(isPresented: $viewModel.showAlert, content: alert)
        .onAppear {
            message = passthroughtNote.content
        }
    }
    
    func alert() -> Alert {
        if viewModel.resourceInfo == .success {
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                dismissButton: .default(Text("OK")) {
                    dismiss()
                })
        } else {
            
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                primaryButton: .default(Text("Thử lại")) {
                    viewModel.processNote(note: passthroughtNote)
                },
                secondaryButton: .cancel(Text("Huỷ bỏ")) {
                    dismiss()
                })
        }
    }
    
    private func dismiss() {
        passthroughtNote.reset()
        presentationMode.wrappedValue.dismiss()
    }
}

struct AddNoteView_Previews: PreviewProvider {
    static var previews: some View {
        AddNoteView()
    }
}
