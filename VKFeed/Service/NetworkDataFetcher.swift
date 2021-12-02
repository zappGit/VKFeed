//
//  NetworkDataFetcher.swift
//  VKFeed
//
//  Created by Артем Хребтов on 24.10.2021.
//

import Foundation


protocol DataFetcher {
    func getFeed(nextButchFrom: String?, response: @escaping (FeedResponse?) -> Void)
    func getUser(response: @escaping (UserResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
   
    let networking: Networking
    private let authService: AuthService
    
    init(networking: Networking, auth: AuthService = SceneDelegate.shared().authService){
        self.networking = networking
        self.authService = auth
    }
    func getFeed(nextButchFrom: String?, response: @escaping (FeedResponse?) -> Void) {
        var params = ["filters":"post, photo"]
        params["start_from"] = nextButchFrom
        networking.request(path: API.newsFeed, params: params) { data, error in
            if let error = error {
                print("Error \(error.localizedDescription)")
                response(nil)
            }
            
            let decode = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            response(decode?.response)
            
        }
    }
    
    func getUser(response: @escaping (UserResponse?) -> Void) {
        guard let userId = authService.userId else { return }
        let params = ["user_ids": userId, "fields":"photo_100"]
        networking.request(path: API.user, params: params) { data, error in
            if let error = error {
                print("Error \(error.localizedDescription)")
                response(nil)
            }
            
            let decode = self.decodeJSON(type: UserResponseWrapted.self, from: data)
            response(decode?.response.first)
            
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
    
}
