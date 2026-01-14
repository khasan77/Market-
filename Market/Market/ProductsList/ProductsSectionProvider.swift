//
//  ProductsSectionProvider.swift
//  Market
//
//  Created by Хасан Магомедов on 29.09.2023.
//

struct ProductsSectionProvider {
    
    static func makeSections(completion: @escaping ([ProductSection]) -> Void) {
        let categoryMapping: [String: String] = [
            "laptops": "Популярное",
            "smartphones": "Хиты продаж",
            "tablets": "Распродажа"
        ]
        
        let categories = ["laptops", "smartphones", "tablets"]
        
        ProductService.shared.fetchProductsByCategories(
            categories: categories,
            limitPerCategory: 8
        ) { productsByCategory in
            var sections: [ProductSection] = []
            
            for category in categories {
                if let products = productsByCategory[category],
                   let sectionTitle = categoryMapping[category] {
                    let mappedProducts = ProductMapper.map(products)
                    sections.append(ProductSection(title: sectionTitle, items: mappedProducts))
                }
            }
            
            let finalSections = sections.isEmpty ? fallbackSections() : sections
            completion(finalSections)
        }
    }
    
    private static func fallbackSections() -> [ProductSection] {
        return [
            ProductSection(title: "Популярное", items: []),
            ProductSection(title: "Хиты продаж", items: []),
            ProductSection(title: "Распродажа", items: [])
        ]
    }
}
