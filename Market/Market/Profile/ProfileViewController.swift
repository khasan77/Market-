//
//  ProfileViewController.swift
//  Market
//
//  Created by Хасан Магомедов on 12.10.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let mainView = ProfileView()
    
    private var currentUserId: Int {
        UserDefaults.standard.integer(forKey: "currentUserId")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Профиль"
        
        mainView.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchDown)
        mainView.showOrdersView.addTarget(self, action: #selector(showOrdersButtonTapped), for: .touchDown)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        mainView.userImageView.addGestureRecognizer(tapGesture)
        
        loadUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserData()
    }
    
    // MARK: - Private methods
    
    private func loadUserData() {
        let name = UserDefaults.standard.string(forKey: "currentUserName")
        let phone = UserDefaults.standard.string(forKey: "currentUserPhone")
        mainView.username = name ?? "Гость"
        mainView.userPhoneLabel.text = phone ?? ""
        
        if let avatar = ImageStorageService.shared.loadAvatar(for: currentUserId) {
            mainView.userImageView.image = avatar
        } else {
            mainView.userImageView.image = UIImage(named: "user")
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func avatarTapped() {
        let hasPhoto = ImageStorageService.shared.loadAvatar(for: currentUserId) != nil
        
        let actionSheet = UIAlertController(title: "Фото профиля", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Сделать фото", style: .default) { [weak self] _ in
                self?.showPicker(source: .camera)
            })
        }
        
        actionSheet.addAction(UIAlertAction(title: "Выбрать из галереи", style: .default) { [weak self] _ in
            self?.showPicker(source: .photoLibrary)
        })
        
        if hasPhoto {
            actionSheet.addAction(UIAlertAction(title: "Удалить фото", style: .destructive) { [weak self] _ in
                guard let self else { return }
                ImageStorageService.shared.deleteAvatar(for: self.currentUserId)
                self.mainView.userImageView.image = UIImage(named: "user")
            })
        }
        
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(actionSheet, animated: true)
    }
    
    @objc
    private func logoutButtonTapped() {
        let alert = UIAlertController(
            title: "Выход из аккаунта",
            message: "Вы действительно хотите выйти?",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Да", style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: "currentUserId")
            UserDefaults.standard.removeObject(forKey: "currentUserName")
            UserDefaults.standard.removeObject(forKey: "currentUserPhone")
            
            let nav = UINavigationController(rootViewController: LoginViewController())
            nav.navigationBar.tintColor = .black
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }
            
            UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve) {
                window.rootViewController = nav
            }
        })
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc
    private func showOrdersButtonTapped() {
        let vc = OrderListViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Helpers
    
    private func showPicker(source: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true)
        
        let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage
        guard let image else { return }
        
        mainView.userImageView.image = image
        ImageStorageService.shared.saveAvatar(image, for: currentUserId)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
