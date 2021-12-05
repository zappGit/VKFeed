//
//  NetworkService.swift
//  VKFeed
//
//  Created by Артем Хребтов on 23.10.2021.
//

import Foundation
import VKSdkFramework

protocol Networking {
    func request(path: String, params: [String:String], complition: @escaping (Data?, Error?) -> Void)
}

class NetworkService: Networking {
   
    private let authService: AuthService
    
    init(auth: AuthService = SceneDelegate.shared().authService) {
        self.authService = auth
    }
    
    private func url(from path: String, params: [String:String]) -> URL {
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = params.map {URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    func request(path: String, params: [String : String], complition: @escaping (Data?, Error?) -> Void) {
        guard let token = authService.token else { return }
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version
        
        let url = self.url(from: path, params: allParams)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, complition: complition)
        task.resume()
    }
    
    private func createDataTask(from request: URLRequest, complition: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, responce, error in
            DispatchQueue.main.async {
                complition(data,error)
            }
        }
    }
}
