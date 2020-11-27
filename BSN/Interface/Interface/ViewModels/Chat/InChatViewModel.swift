//
//  InChatViewModel.swift
//  Interface
//
//  Created by Phucnh on 10/2/20.
//

import SwiftUI
import Business

class InChatViewModel: NetworkViewModel {
    
    @Published var messages: [Message]
    @Published var chat: Chat
    @Published var info: String // If don't have any mess, we show this message
    
    // Upload image to S3
    @Published var uploadProgess: Float
    @Published var isUploading: Bool
    
    private var messageManager: MessageManager
    private var chatManager: ChatManager
    
    // Did send new message
    // It's content should be force UI scroll to bottom
    var updateUIIfNeedes: (() -> Void)?
    
    override init() {
        messages = []
        chat = Chat()
        info = ""
        
        uploadProgess = 0
        isUploading = false
        
        messageManager = MessageManager()
        chatManager = ChatManager()
        
        super.init()
        observerSaveMessage()
        observerGetMessages()
        observerGetChat()
    }
    
    func fetchData(chat: Chat) {
        self.isLoading = true
        self.chat = chat
        
        if chat.id != kUndefine && chat.id != nil {
            // fetch message of this chat
            fetchMessages(page: 0)
        } else {
            // Get chat info by curren user and parter user
            // It called usualy because user search new chat
            // It can be new or exists chat in DB
            // then fetch message of this chat if exists
            chatManager.getChat(uid1: chat.partnerID, uid2: AppManager.shared.currenUID)
        }
    }
    
    func fetchMessages(page: Int) {
        messageManager.getMessages(page: page, chatID: chat.id!)
    }
    
    // if message type is photo. no need using content
    func didChat(type:MessageType, content: String = "") {
        
        let newMessage = Message(
            sender: AppManager.shared.currenUID,
            receiver: chat.partnerID,
            content: content,
            type: type
        )
        
        pushToUI(mess: newMessage)
        pushToServer(mess: newMessage)
    }
    
    func pushToUI(mess: Message) {
        // update on UI and force scroll to bottom most
        messages.append(mess)
        self.objectWillChange.send()
        self.updateUIIfNeedes?()
    }
    
    func pushToServer(mess: Message) {
        // To -Do
        // Call to bussiness layer to call server
        let newMessage = EMessage(
            chatID: chat.id,
            senderID: AppManager.shared.currenUID,
            typeName: mess.type.rawValue,
            content: mess.content!,
            receiverID: chat.partnerID
        )
        
        messageManager.saveMess(message: newMessage)
    }
}

// MARK: - Observer method
extension InChatViewModel {
    private func observerSaveMessage() {
        messageManager
            .saveMessPublisher
            .sink {[weak self] (mess) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if mess.id == kUndefine {
                        self.resourceInfo = .savefailure
                        self.showAlert = true
                    } else {
                        
                        self.resourceInfo = .success
                    }
                    
                }
            }
            .store(in: &cancellables)
    }
    
    private func observerGetMessages() {
        messageManager
            .getMessagesPublisher
            .sink {[weak self] (messages) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if messages.isEmpty {
                        self.info = "Soạn và gửi tin đầu tiên của bạn"
                    } else {
                        if messages[0].id == kUndefine {
                            self.resourceInfo = .getfailure
                            self.showAlert = true
                        } else {
                            messages.forEach { (m) in
                                let model = Message(sender: m.senderID ,content: m.content, type: m.typeName!, createAt: m.createAt!)
                                self.messages.insertUnique(item: model)
                            }
                        }
                    }
                    
                }
            }
            .store(in: &cancellables)
    }
    
    private func observerGetChat() {
        chatManager
            .getChatPublisher
            .sink {[weak self] (chat) in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    // This chat was text before (not new),
                    // So we need get message of this chat
                    if chat.id! != kUndefine {
                        self.chat.id = chat.id
                        self.fetchMessages(page: 0)
                    }
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - AWS Utils
extension InChatViewModel {
    func upload(image: UIImage) {
        isUploading = true
        AWSManager.shared.uploadImage(image: image, progress: {[weak self] ( uploadProgress) in
            
            guard let strongSelf = self else { return }
            strongSelf.uploadProgess = Float(uploadProgress)
            
        }) {[weak self] (uploadedFileUrl, error) in
            
            guard let strongSelf = self else { return }
            if let finalPath = uploadedFileUrl as? String {
                //strongSelf.photoUrl = finalPath
                // request make send message
                strongSelf.didChat(type: .photo, content: finalPath)
            } else {
                //strongSelf.photoUrl = ""
                strongSelf.resourceInfo = .image_upload_fail
                strongSelf.showAlert = true
                print("\(String(describing: error?.localizedDescription))")
            }
            strongSelf.isUploading = false
        }
    }
}
