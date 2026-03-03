//
//  ApiErrorResponse.swift
//  Market
//
//  Created by Хасан Магомедов on 16.02.2026.
//

import Foundation

// Вложенная часть detail: { "error": "...", "message": "..." }
struct ApiErrorDetail: Codable {
    let error: String?
    let message: String?
}

// FastAPI оборачивает ошибки в { "detail": { ... } }
struct ApiErrorResponse: Codable {
    let detail: ApiErrorDetail?
    
    var errorMessage: String? {
        return detail?.message
    }
    
    var errorCode: String? {
        return detail?.error
    }
}
