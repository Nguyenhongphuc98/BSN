//
//  ReactionManager.swift
//  Business
//
//  Created by Phucnh on 11/25/20.
//
import Combine

// Because we don't care result, just using singletone enought for business
public class ReactionManager {
    
    private let networkRequest: ReactionRequest
    
    public static var shared: ReactionManager = ReactionManager()
    
    public init() {
        // Init resource URL
        networkRequest = ReactionRequest(componentPath: "reactions/")
    }
    
    public func makeReact(reaction: EReaction) {
        networkRequest.saveReaction(reaction: reaction)
    }
    
    public func unReact(uid: String, pid: String) {
        networkRequest.deleteReaction(uid: uid, pid: pid)
    }
}
