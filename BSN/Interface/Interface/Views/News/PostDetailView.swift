//
//  PostDetailView.swift
//  Interface
//
//  Created by Phucnh on 9/30/20.
//

import SwiftUI

struct PostDetailView: View {
    
    @StateObject private var viewModel: PostDetailViewModel = .init()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var postID: String = ""
    
    @State private var post: NewsFeed = NewsFeed()
    
    @State private var isShowProfile: Bool = false
    @State private var selectedUserID: String = ""
    
    var didReact: ((NewsFeed) -> Void)?
    
    init(post: NewsFeed, didReact: ((NewsFeed) -> Void)? = nil) {
        self.post.clone(from: post)
        self.didReact = didReact
    }
    
    init(postID: String) {
        self._postID = State(initialValue: postID)
    }
    
    var body: some View {
        VStack {
            if viewModel.post != nil {
                postContent
                
                // Progess bar (uploading)
                if viewModel.isUploading {
                    ProgressView("Đang xử lý ảnh", value: viewModel.uploadProgess, total: 1)
                        .progressViewStyle(LinearProgressViewStyle())
                        .padding()
                }
            } else {
                ExceptionView(sign: "exclamationmark.circle", message: "Bài viết đã bị gỡ bỏ!")
            }
        }
        .embededLoadingFull(isLoading: $viewModel.isLoading)
        .navigationBarTitle("Bình luận", displayMode: .inline)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .onAppear(perform: viewAppeared)
    }
    
    var backButton: some View {
        Button {
            if let p = viewModel.post {
                didReact?(p)
            }            
            presentationMode.wrappedValue.dismiss()
        } label: {
            BackWardButton()
        }
    }
    
    var title: Text {
        Text("Bình luận").robotoBold(size: 13)
    }
    
    var postContent: some View {
        ZStack(alignment: .bottom) {
            ScrollView(.vertical) {
                navToProfileLabel
                
                // Main post
                NewsFeedCard(model: viewModel.post!,
                             isDetail: true,
                             didRequestGoToProfile: {
                                selectedUserID = viewModel.post!.owner.id
                                isShowProfile = true
                             })
                
                Separator()
                
                HStack {
                    if viewModel.isLoadingComment {
                        CircleLoading(frame: CGSize(width: 15, height: 15))
                    } else {
                        if viewModel.canLoadMore {
                            Button {
                                viewModel.loadMore()
                            } label: {
                                Text("Tải thêm bình luận")
                                    .font(.system(size: 13))
                                    .foregroundColor(.black)
                                    .bold()
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.leading, 25)
                
                // List comments
                //if viewModel.comments != nil {
                    ForEach(viewModel.comments) { comment in
                        CommentCard(model: comment) { (comment, name) in
                            viewModel.replingComment = comment
                            viewModel.replingName = name
                            viewModel.objectWillChange.send()
                        }                        
                    }
                    .environmentObject(viewModel)
               // }
                
                Spacer()
            }
            .resignKeyboardOnDragGesture()
            .padding(.bottom, 45)
            
            commentBox
        }
    }
    
    var commentBox: some View {
        VStack(spacing: 1) {
            
            // Thumnail image when upload image for comment
            HStack {
                if !viewModel.uploadedPhoto.isEmpty {
                    ImageWithCloseBtn(
                        photoUrl: $viewModel.uploadedPhoto,
                        frame: CGSize(width: 100, height: 80),
                        didClose: {
                            viewModel.objectWillChange.send()
                        })
                }
                
                if !viewModel.uploadedSticker.isEmpty {
                    ImageWithCloseBtn(
                        photoUrl: $viewModel.uploadedSticker,
                        frame: CGSize(width: 100, height: 80),
                        isRemote: false,
                        didClose: {
                           viewModel.objectWillChange.send()
                       })
                }
                Spacer()
            }
            .padding(.leading, 30)
            
            if !viewModel.replingComment.isDummy() {
                HStack(spacing: 0) {
                    Text("Bạn đang trả lời \(viewModel.replingName)...")
                        .foregroundColor(._primary)
                        .robotoLightItalic(size: 15)
                        .background(Color(.secondarySystemBackground))
                    
                    Button(action: {
                        // force to replace and emit signal to know we clear reply cmt
                        viewModel.replingComment = Comment(dummy: true)
                        viewModel.objectWillChange.send()
                    }, label: {
                        Image(systemName: "xmark")
                    })
                    .padding(2)
                    .background(Color(.secondarySystemBackground))
                    
                    Spacer()
                }
            }
            
//            CoreMessageEditor(placeHolder: "Nhập bình luận") { (message) in
//                viewModel.didComment(message: message)
//            }
            //editorBox
            RichMessageEditor(didChat: { (type, message) in
                // if type == text mean submit chat
                // else we just pick sticker
                if type == .sticker {
                    viewModel.uploadedSticker = message
                    viewModel.uploadedPhoto = ""
                    viewModel.objectWillChange.send()
                } else {
                    viewModel.didComment(message: message)
                }
            }, didPickPhoto: { (img) in
                viewModel.uploadedSticker = ""
                viewModel.upload(image: img)
            }, didExpand: { expand, type in
                 
            })
            .background(Color.white)
            .padding(.top, 5)
        }
        //.padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var navToProfileLabel: some View {
        NavigationLink(
            destination: ProfileView(uid: selectedUserID, vm: ProfileViewModel())
                .environmentObject(NavigationState()),
            isActive: $isShowProfile
        ) {
            EmptyView()
        }
        .frame(width: 0, height: 0)
        .opacity(0)
    }
    
    func viewAppeared() {
        viewModel.prepareData(postID: postID, post: post)
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: NewsFeed())
    }
}
