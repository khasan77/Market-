//
//  ProductsListViewModel.swift
//  Market
//
//  Created by Хасан Магомедов on 08.01.2026.
//

import Foundation
import Combine

final class ProductsListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var sections: [ProductSection] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    
    private let productService: ProductService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(productService: ProductService = .shared) {
        self.productService = productService
    }
    
    // MARK: - Public Methods
    
    func loadProducts() {
        isLoading = true
        errorMessage = nil
        
        let categoryMapping: [String: String] = [
            "laptops": "Популярное",
            "smartphones": "Хиты продаж",
            "tablets": "Распродажа"
        ]
        
        let categories = ["laptops", "smartphones", "tablets"]
        
        productService.fetchProductsByCategories(
            categories: categories,
            limitPerCategory: 8
        ) { [weak self] productsByCategory in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                var sections: [ProductSection] = []
                
                for category in categories {
                    if let products = productsByCategory[category],
                       let sectionTitle = categoryMapping[category] {
                        let mappedProducts = ProductMapper.map(products)
                        sections.append(ProductSection(title: sectionTitle, items: mappedProducts))
                    }
                }
                
                // возвращаем пустые разделы при ошибке апи
                if sections.isEmpty {
                    sections = self.fallbackSections()
                }
                
                self.sections = sections
                self.isLoading = false
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func fallbackSections() -> [ProductSection] {
        return [
            ProductSection(title: "Популярное", items: []),
            ProductSection(title: "Хиты продаж", items: []),
            ProductSection(title: "Распродажа", items: [])
        ]
    }
}
