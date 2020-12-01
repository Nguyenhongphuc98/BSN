//
//  CommentManager.swift
//  Business
//
//  Created by Phucnh on 11/24/20.
//
import Combine

public class CommentManager {
    
    private let networkRequest: CommentRequest
    
    // save and delete
    public let commentPublisher: PassthroughSubject<EComment, Never>
    // get posts
    public let commentsPublisher: PassthroughSubject<[EComment], Never>
    
    // Observer new message come
    public let receiveCommentPublisher: PassthroughSubject<EComment, Never>
    private let webSocket: SocketFollow<EComment>
    
    public init() {
        // Init resource URL
        networkRequest = CommentRequest(componentPath: "comments/")
        
        commentPublisher = PassthroughSubject<EComment, Never>()
        commentsPublisher = PassthroughSubject<[EComment], Never>()
        
        // WebSocket
        receiveCommentPublisher = PassthroughSubject<EComment, Never>()
        webSocket = SocketFollow()
    }
    
    public func saveComment(comment: EComment) {
        networkRequest.saveComment(comment: comment, publisher: commentPublisher)
    }
    
    public func getNewestComments(pid: String, page: Int) {
        if page == 0 {
            // Setup receive data for first time fetch data
            webSocket.connect(url: wsCommentsOfPostApi + pid)
            webSocket.didReceiveData = { message in
                print("Business did receive new comment: \(message.content)")
                self.receiveCommentPublisher.send(message)
            }
        }
        networkRequest.fetchNewsestComments(pid: pid, page: page, per: BusinessConfigure.newestCommentsPerPage, publisher: commentsPublisher)
    }
    
    public func getSubComments(parentId: String) {
        networkRequest.fetchSubComments(parentId: parentId, publisher: commentsPublisher)
    }
    
    public func deleteComment(commentID: String) {
        networkRequest.deleteComment(commentID: commentID)
    }
}
