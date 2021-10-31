//
//  WebImageView.swift.swift
//  VKFeed
//
//  Created by Артем Хребтов on 31.10.2021.
//

import Foundation
import UIKit

class WebImageView: UIImageView {
    func set(imgUrl: String?){
        guard let imgUrl = imgUrl, let url = URL(string: imgUrl) else { return }
        
        if let cacheResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cacheResponse.data)
            return
        }
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.image = UIImage(data: data)
                    self?.handleLoadedImage(data: data, response: response)
                }
            }
        }
        dataTask.resume()
    }
    
    func handleLoadedImage(data: Data, response: URLResponse){
        guard let responseURL = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
    }
}
