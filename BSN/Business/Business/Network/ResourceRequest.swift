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


class ResourceRequest<ResourceType> where ResourceType: Codable {
    
    // Connect to root server
    let baseURL = "http://localhost:8080/api/v1/"
    
    // Connect to a component of server
    var componentPath: String
    
    // Connect to special resource
    var resourceURL: URL
    
    init(componentPath: String) {
        self.componentPath = baseURL + componentPath
        self.resourceURL = URL(string: self.componentPath)!
    }
    
    func setPath(resourcePath: String, params: [String:String] = [:]) {
        var urlComponent = URLComponents(string: componentPath + resourcePath)!

        // Setup query
        if resourcePath == "search" {
            urlComponent.queryItems = []
            params.keys.forEach { (key) in
                let queryItem = URLQueryItem(name: key, value: params[key])
                urlComponent.queryItems!.append(queryItem)
            }
        }
        resourceURL = urlComponent.url!
    }
    
    // Get all data from base url
    func get(isAll: Bool = true, completion: @escaping (GetResourcesRequest<ResourceType>) -> Void) {
        //let desUrl = url ?? self.resourceURL
        
        let dataTask = URLSession.shared
            .dataTask(with: resourceURL) { data, _, _ in
                
                guard let jsonData = data else {
                    completion(.failure)
                    return
                }
                
                do {
                    if isAll {
                        let resources  = try JSONDecoder().decode([ResourceType].self, from: jsonData)
                        completion(.success(resources))
                    } else {
                        let resources  = try JSONDecoder().decode(ResourceType.self, from: jsonData)
                        completion(.success([resources]))
                    }
                }
                catch {

                    completion(.failure)
                }
            }
        
        dataTask.resume()
    }
}
