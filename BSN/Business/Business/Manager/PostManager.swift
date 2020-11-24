//
//  PostManager.swift
//  Business
//
//  Created by Phucnh on 11/23/20.
//

import Combine

public class PostManager {
    
    private let networkRequest: PostRequest
    
    // save and delete
    public let postPublisher: PassthroughSubject<EPost, Never>
    
    // get posts
    public let postsPublisher: PassthroughSubject<[EPost], Never>
    
    public init() {
        // Init resource URL
        networkRequest = PostRequest(componentPath: "posts/")
        
        postPublisher = PassthroughSubject<EPost, Never>()
        postsPublisher = PassthroughSubject<[EPost], Never>()
    }
    
    public func savePost(post: EPost) {
        networkRequest.savePost(post: post, publisher: postPublisher)
    }
    
    public func getNewestPosts(page: Int) {
        networkRequest.fetchNewsestPosts(page: page, per: BusinessConfigure.newestPostsPerPage, publisher: postsPublisher)
    }
    
    public func deletePost(postID: String) {
        networkRequest.deletePost(postID: postID)
    }
}
