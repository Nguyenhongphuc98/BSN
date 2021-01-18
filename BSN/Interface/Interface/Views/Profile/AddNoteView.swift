//
//  AddNoteView.swift
//  Interface
//
//  Created by Phucnh on 10/11/20.
//

import SwiftUI

// Add new node or update exist node
struct AddNoteView: View {
    
    //@EnvironmentObject var viewModel: MyBookDetailViewModel
    @StateObject var viewModel: AddNoteViewModel = .init()
    
    /// Note `undefine` mean add new, else update
    @EnvironmentObject private var passthroughtNote: Note
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var message: String = ""
    @State var refPageNum: String = ""
    
    @State var showActionSheet: Bool = false
    @State var showImageCapture: Bool = false
    @State var imageSource: ImageSourceType = .gallery
    
    var didRating: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 20) {
                    Text("\(passthroughtNote.isUndefine() ? "Thêm" : "Cập nhật") bài học")
                        .robotoBold(size: 18)
                    
                    VStack {
                        image
                            .sheet(isPresented: $showImageCapture) {
                                CaptureImageView(isShown: $showImageCapture, source: imageSource) { (uiimage) in
                                    print("did get image...")
                                    viewModel.upload(image: uiimage)
                                }
                            }
                        
                        Text(viewModel.uploadMessage)
                            .roboto(size: 13)
                            .foregroundColor(.red)
                    }
                    
                    VStack {
                        HStack {
                            Text("Trang tham chiếu:").roboto(size: 17)
                            InputHighlightBorder(content: $refPageNum, placer: "VD: 17")
                        }
                        
                        EditorWithPlaceHolder(text: $message, placeHolder: "Để lại bài học của bạn tại đây")
                            .frame(height: 100)
                            .cornerRadius(5)
                    }
                    .padding()
                    
                    Spacer()
                    
                    submitBtn
                    
                    Spacer()
                }
                .padding()
            }
                        
            cancelBtn
        }
        .background(Color(.secondarySystemBackground))
        .embededLoading(isLoading: $viewModel.isLoading)
        .alert(isPresented: $viewModel.showAlert, content: alert)
        .onAppear {
            message = passthroughtNote.content
            refPageNum = passthroughtNote.page ?? ""
            viewModel.photoUrl = passthroughtNote.photoUrl ?? ""
            viewModel.objectWillChange.send()
        }
    }
    
    var submitBtn: some View {
        Button(action: {
            passthroughtNote.content = message
            passthroughtNote.page = refPageNum
            viewModel.processNote(note: passthroughtNote)
        },
        label: {
            Text("   \(passthroughtNote.isUndefine() ? "Lưu" : "Cập nhật") bài học   ")
        })
        .buttonStyle(BaseButtonStyle(size: .large))
    }
    
    var cancelBtn: some View {
        HStack {
            Button(action: { dismiss() }, label: {
                Text("Huỷ").padding()
            })
            
            Spacer()
        }
    }
    
    var image: some View {
        Group {
            if viewModel.isUploading {
                ProgressView()
            } else {
                if viewModel.photoUrl.isEmpty {
                    Button {
                        showActionSheet.toggle()
                    } label: {
                        Image("icimage", bundle: interfaceBundle)
                            .resizable()
                            .frame(width: 60, height: 60)
                    }
                    .actionSheet(isPresented: $showActionSheet) {
                        ActionSheet(title: Text("Lựa chọn hành động với ảnh"), buttons: actionSheetButton)
                    }
                    
                } else {
                    ImageWithCloseBtn(photoUrl: $viewModel.photoUrl, didClose: {
                        viewModel.objectWillChange.send()
                    })
                }
            }
        }
    }
    
    var actionSheetButton: [Alert.Button] {
        [
            .default(Text("Chụp ảnh mới")) {
                imageSource = .camera
                showImageCapture.toggle()
            },
            .default(Text("Chọn từ thư viện")) {
                imageSource = .gallery
                showImageCapture.toggle()
            },
            .cancel()
        ]
    }
    
    func alert() -> Alert {
        if viewModel.resourceInfo == .success {
            return Alert(
                title: Text("Kết quả"),
                message: Text(viewModel.resourceInfo.des()),
                dismissButton: .default(Text("OK")) {
                    didRating?()
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
