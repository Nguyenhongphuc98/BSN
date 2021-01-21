//
//  RichMessageEditor.swift
//  Interface
//
//  Created by Phucnh on 10/4/20.
//

import SwiftUI
import Combine

enum EditorExpandType {
    case keyboard
    case sticker
}

struct RichMessageEditor: View {
    
    var didChat: ((MessageType, String) -> Void)?
    
    var didPickPhoto: ((UIImage) -> Void)?
    
    var didExpand: ((Bool, EditorExpandType) -> Void)?
    
    @State var showStickersBar: Bool = false
    
    //@State var showImagePicker: Bool = false
    
    @State var showActionSheet: Bool = false
    @State var showImageCapture: Bool = false
    @State var imageSource: ImageSourceType = .gallery
    
    @EnvironmentObject var root: AppManager
    
    @State var cancellables = Set<AnyCancellable>()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    //showImagePicker.toggle()
                    //showImageCapture.toggle()
                    showActionSheet.toggle()
                }, label: {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(.gray)
                })
                
                Button(action: {
                    
                    UIApplication.shared.endEditing(true)
                    showStickersBar.toggle()
                    didExpand?(showStickersBar, .sticker)
                }, label: {
                    Image(systemName: "face.dashed.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(showStickersBar ? .blue : .gray)
                })
                
                CoreMessageEditor(placeHolder: "Nhập tin nhắn") { (message) in
                    didChat?(.text, message)
                }
            }
            .padding(.bottom, 10)
            .padding(.top, 0)
            .padding(.horizontal)
            
            if showStickersBar {
                StickerGrid() { sticker in
                    didChat?(.sticker, sticker)
                }
                .frame(maxHeight: 253)
            }
        }
        .animation(.easeIn)
        .onAppear(perform: viewAppeared)
//        .sheet(isPresented: $showImagePicker) {
//            ImagePicker(picker: $showImagePicker) { img in
//                didPickPhoto?(img)
//            }
//        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("Lựa chọn hành động với ảnh"), buttons: actionSheetButton)
        }
        .sheet(isPresented: $showImageCapture) {
            CaptureImageView(isShown: $showImageCapture, source: imageSource) { (uiimage) in
                didPickPhoto?(uiimage)
            }
        }
    }
    
    private var actionSheetButton: [Alert.Button] {
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
    
    private func viewAppeared() {
        root.$keyboardHeight
            .sink { (height) in
                if height != 0 {
                    showStickersBar = false
                    didExpand?(true, .keyboard)
                } else {
                    didExpand?(showStickersBar, .sticker)
                }
            }
            .store(in: &cancellables)
    }
}

struct RichMessageEditor_Previews: PreviewProvider {
    static var previews: some View {
        RichMessageEditor()
    }
}
