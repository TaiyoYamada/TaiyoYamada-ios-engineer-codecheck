//
//  ImageLoaderProtocol.swift
//  iOSEngineerCodeCheck
//
//  Created by 山田大陽 on 2025/08/24.
//  Copyright © 2025 YUMEMI Inc. All rights reserved.
//


import UIKit

// MARK: - Image Loading

protocol ImageLoaderProtocol {
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void)
    func cancelCurrentLoad()
}

class ImageLoader: ImageLoaderProtocol {
    private var imageLoadTask: URLSessionDataTask?
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageURL = URL(string: urlString) else {
            completion(UIImage(systemName: "person.circle"))
            return
        }
        
        cancelCurrentLoad()
        
        imageLoadTask = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            // キャンセルされた場合は処理を中断
            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                return
            }
            
            guard error == nil,
                  let data = data,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(UIImage(systemName: "person.circle"))
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        imageLoadTask?.resume()
    }
    
    func cancelCurrentLoad() {
        imageLoadTask?.cancel()
    }
}
