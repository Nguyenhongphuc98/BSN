//
//  ReactionRequest.swift
//  Business
//
//  Created by Phucnh on 11/25/20.
//
import Combine

class ReactionRequest: ResourceRequest<EReaction> {
    
    func saveReaction(reaction: EReaction) {
        self.resetPath()
        
        self.save(reaction) { result in
            switch result {
            case .failure:
                let message = "There was an error make reaction - isheart: \(reaction.isHeart)"
                print(message)
                
            case .success(let r):
                print("reaction success: isHeart - \(r.isHeart)")
            }
        }
    }

    func deleteReaction(uid: String, pid: String) {
        self.setPath(resourcePath: "delete", params: ["uid" : uid, "pid" : pid])
        self.delete()
    }
}
