//
//  ResourceRequest.swift
//  Business
//
//  Created by Phucnh on 10/20/20.
//

import Foundation

enum GetResourcesRequest<ResourceType> {
  case success([ResourceType])
  case failure
}


struct ResourceRequest<ResourceType> where ResourceType: Codable {
    
    // Connect to root server
    let baseURL = "http://localhost:8080/api/v1/"
    
    // Connect to a component of server
    let componentURL: URL
    
    // Connect to special resource
    var resourceURL: URL
    
    init(componentPath: String) {
        let fullPath = baseURL + componentPath
        guard let componentURL = URL(string: fullPath) else {
            fatalError()
        }
        self.componentURL = componentURL
        self.resourceURL = componentURL
    }
    
    func setPath(resourcePath: String) {
        var _self = self
        _self.resourceURL = componentURL.appendingPathComponent(resourcePath)
    }
    
    func getAll(completion: @escaping (GetResourcesRequest<ResourceType>) -> Void) {
        let dataTask = URLSession.shared
            .dataTask(with: resourceURL) { data, _, _ in
                
                guard let jsonData = data else {
                    completion(.failure)
                    return
                }
                
                do {
                    let resources  = try JSONDecoder().decode([ResourceType].self, from: jsonData)
                    completion(.success(resources))
                } catch {
                    
                    completion(.failure)
                }
            }
        
        dataTask.resume()
    }
}
