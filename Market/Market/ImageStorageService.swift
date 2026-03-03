//
//  ImageStorageService.swift
//  Market
//
//  Created by Хасан Магомедов on 27.02.2026.
//

import UIKit

final class ImageStorageService {
    
    static let shared = ImageStorageService()
    
    private init() {}
    
    // Сохраняет фото пользователя в Documents
    func saveAvatar(_ image: UIImage, for userId: Int) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        let url = avatarURL(for: userId)
        try? data.write(to: url)
    }
    
    // Загружает фото пользователя из Documents
    func loadAvatar(for userId: Int) -> UIImage? {
        let url = avatarURL(for: userId)
        guard let data = try? Data(contentsOf: url) else { return nil }
        return UIImage(data: data)
    }
    
    // Удаляет фото пользователя
    func deleteAvatar(for userId: Int) {
        let url = avatarURL(for: userId)
        try? FileManager.default.removeItem(at: url)
    }
    
    private func avatarURL(for userId: Int) -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent("avatar_\(userId).jpg")
    }
}
