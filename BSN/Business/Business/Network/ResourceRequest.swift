//
//  ResourceRequest.swift
//  Business
//
//  Created by Phucnh on 10/20/20.
//

import Foundation
import SwiftyJSON

enum GetResourcesRequest<ResourceType> {
    case success([ResourceType])
    case failure(String)
}

enum SaveResult<ResourceType> {
    case success(ResourceType)
    case failure
}

class ResourceRequest<ResourceType>  where ResourceType: Codable {
    
    // Connect to root server
    let baseURL = "http://localhost:8080/api/v1/"
    //let baseURL = "http://bsn.local:8080/api/v1/"
    //let baseURL = "http://192.168.0.100:8080/api/v1/"
    
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
        urlComponent.queryItems = []
        params.keys.forEach { (key) in
            let queryItem = URLQueryItem(name: key, value: params[key])
            urlComponent.queryItems!.append(queryItem)
        }
        
        resourceURL = urlComponent.url!
    }
    
    func resetPath() {
        self.resourceURL = URL(string: self.componentPath)!
    }
    
    // Get all data from base url
    func get(isAll: Bool = true, completion: @escaping (GetResourcesRequest<ResourceType>) -> Void) {
        //let desUrl = url ?? self.resourceURL
        print("url: \(resourceURL.absoluteURL)")
        
        var urlRequest = URLRequest(url: resourceURL)
        urlRequest.httpMethod = "get"
        urlRequest.addValue(AccountRequest.authorization, forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared
            .dataTask(with: urlRequest) { data, _, _ in
                
                guard let jsonData = data else {
                    completion(.failure("parse error"))
                    return
                }
                
                do {
                    if isAll {
                        let resources  = try! JSONDecoder().decode([ResourceType].self, from: jsonData)
                        completion(.success(resources))
                    } else {
                        let resources  = try! JSONDecoder().decode(ResourceType.self, from: jsonData)
                        completion(.success([resources]))
                    }
                }
                catch {
                    let json = JSON(jsonData)
                    let reason = json["reason"].string!
                    completion(.failure(reason))
                }
            }
        
        dataTask.resume()
    }
    
    func save(_ resourceToSave: ResourceType, completion: @escaping (SaveResult<ResourceType>) -> Void) {
       changeResource(resourceToSave, method: "POST", completion: completion)
    }
    
    func update(_ resourceToSave: ResourceType, completion: @escaping (SaveResult<ResourceType>) -> Void) {
       changeResource(resourceToSave, method: "PUT", completion: completion)
    }
    
    func delete() {
        var urlRequest = URLRequest(url: resourceURL)
        urlRequest.httpMethod = "DELETE"
        let dataTask = URLSession.shared.dataTask(with: urlRequest)
        dataTask.resume()
    }
    
    func changeResource(_ resourceToSave: ResourceType, method: String, completion: @escaping (SaveResult<ResourceType>) -> Void) {
        do {
            
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = method
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue(AccountRequest.authorization, forHTTPHeaderField: "Authorization")
            urlRequest.httpBody = try JSONEncoder().encode(resourceToSave)
            
            print("url: \(urlRequest)")
            
            let dataTask = URLSession.shared
                .dataTask(with: urlRequest) { data, response, _ in
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200, let jsonData = data else {
                        completion(.failure)
                        return
                    }
                    do {
                        let resource = try! JSONDecoder().decode(ResourceType.self,
                                                     from: jsonData)
                        completion(.success(resource))
                    } catch {
                        completion(.failure) }
                }
            
            dataTask.resume()
            
        } catch {
            completion(.failure)
        }
    }
}
