//
//  ImageLoader.swift
//  Market
//
//  Created by Хасан Магомедов on 06.01.2026.
//

import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            if let error = error {
                print("Error loading image from \(urlString): \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            self.cache.setObject(image, forKey: urlString as NSString)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
