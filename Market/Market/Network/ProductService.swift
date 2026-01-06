//
//  ProductService.swift
//  Market
//
//  Created by Хасан Магомедов on 06.01.2026.
//

import Foundation

enum ProductServiceError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
}

final class ProductService {
    
    static let shared = ProductService()
    
    private let baseURL = "https://dummyjson.com/products"
    
    private init() {}
    
    func fetchProducts(
        category: String = "laptops",
        limit: Int = 20,
        completion: @escaping (Result<[ApiProduct], ProductServiceError>) -> Void
    ) {
        let urlString = "\(baseURL)/category/\(category)?limit=\(limit)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ApiProductResponse.self, from: data)
                completion(.success(response.products))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(.decodingError))
            }
        }.resume()
    }
    
    func fetchProductsByCategories(
        categories: [String],
        limitPerCategory: Int = 8,
        completion: @escaping ([String: [ApiProduct]]) -> Void
    ) {
        let dispatchGroup = DispatchGroup()
        var result: [String: [ApiProduct]] = [:]
        let resultQueue = DispatchQueue(label: "com.market.productService.result")
        
        for category in categories {
            dispatchGroup.enter()
            fetchProducts(category: category, limit: limitPerCategory) { resultValue in
                resultQueue.async {
                    switch resultValue {
                    case .success(let products):
                        result[category] = products
                    case .failure(let error):
                        print("Error fetching category \(category): \(error)")
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(result)
        }
    }
}
