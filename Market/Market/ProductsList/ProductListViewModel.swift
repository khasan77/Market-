//
//  ProductListViewModel.swift
//  Market
//
//  Created by Хасан Магомедов on 08.01.2026.
//

import Foundation
import Combine

final class ProductListViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var sections: [ProductSection] = []
    @Published var isSearching: Bool = false
    @Published var searchQuery: String = ""
    
    // MARK: - Private Properties
    
    private var storedSections: [ProductSection] = []
    private var searchResultSection: ProductSection?
    private let productService: ProductService
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(productService: ProductService = .shared) {
        self.productService = productService
        
        // так скажем слежка для изменения запросов поиска 
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    func loadProducts() {
        // Map API categories to section titles
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
                
                // вернем пустые при ошибке апи 
                if sections.isEmpty {
                    sections = self.fallbackSections()
                }
                
                self.storedSections = sections
                self.updateSections()
            }
        }
    }
    
    func search(query: String) {
        if query.isEmpty {
            isSearching = false
            searchResultSection = nil
            updateSections()
        } else {
            isSearching = true
        }
        searchQuery = query
    }
    
    func cancelSearch() {
        searchQuery = ""
        searchResultSection = nil
        isSearching = false
        updateSections()
    }
    
    // MARK: - Private Methods
    
    private func performSearch(query: String) {
        if query.isEmpty {
            searchResultSection = nil
            isSearching = false
        } else {
            let allItems = storedSections.flatMap { $0.items }
            
            let filteredItems = allItems.filter { item in
                item.title.lowercased().contains(query.lowercased())
            }
            
            if !filteredItems.isEmpty {
                searchResultSection = ProductSection(title: "Результат поиска", items: filteredItems)
            } else {
                searchResultSection = nil
            }
        }
        
        updateSections()
    }
    
    private func updateSections() {
        let newSections: [ProductSection]
        
        if let searchResultSection = searchResultSection {
            newSections = [searchResultSection]
        } else if isSearching {
            newSections = []
        } else {
            newSections = storedSections
        }
        
        // обновляем, только если секция изменилась
        if newSections != sections {
            sections = newSections
        }
    }
    
    private func fallbackSections() -> [ProductSection] {
        return [
            ProductSection(title: "Популярное", items: []),
            ProductSection(title: "Хиты продаж", items: []),
            ProductSection(title: "Распродажа", items: [])
        ]
    }
}
