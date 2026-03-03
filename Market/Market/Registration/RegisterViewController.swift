//
//  RegisterViewController.swift
//  Market
//
//  Created by Хасан Магомедов on 12.10.2023.
//

import UIKit

final class RegisterViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let mainView = RegisterView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Регистрация"
        
        view.backgroundColor = .white
        
        mainView.registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchDown)
        mainView.passwordTextField.isSecureTextEntry = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userImageViewTapped))
        mainView.userImageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc
    private func registerButtonTapped() {
        mainView.activityIndicatior.startAnimating()
        // 1. Получаем данные из полей
        guard let name = mainView.nameTextField.text, !name.isEmpty,
              let phone = mainView.phoneTextField.text, !phone.isEmpty,
              let password = mainView.passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Ошибка", message: "Заполните все обязательные поля")
            return
        }
        
        // 2. Показываем индикатор загрузки
        mainView.activityIndicatior.startAnimating()
        mainView.registerButton.isEnabled = false
        
        // 3. Вызываем AuthService
        AuthService.shared.register(
            name: name,
            phone: phone,
            password: password
        ) { [weak self] result in
            // 4. Обрабатываем результат в главном потоке
            DispatchQueue.main.async {
                self?.mainView.activityIndicatior.stopAnimating()
                self?.mainView.registerButton.isEnabled = true
                
                switch result {
                case .success(let userResponse):
                    print("✅ Регистрация успешна! User ID: \(userResponse.userId)")
                    
                    UserDefaults.standard.set(userResponse.userId, forKey: "currentUserId")
                    UserDefaults.standard.set(userResponse.customerName, forKey: "currentUserName")
                    UserDefaults.standard.set(userResponse.customerPhone, forKey: "currentUserPhone")
                    
                    // Сохраняем выбранное фото (если пользователь его выбрал)
                    let defaultImage = UIImage(named: "user")
                    if let avatar = self?.mainView.userImageView.image, avatar != defaultImage {
                        ImageStorageService.shared.saveAvatar(avatar, for: userResponse.userId)
                    }
                    
                    let tabBar = MainTabBarController()
                    tabBar.selectedIndex = 2
                    
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                          let window = windowScene.windows.first else { return }
                    
                    UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve) {
                        window.rootViewController = tabBar
                    }
                    
                case .failure(let error):
                    // Обработка ошибок
                    var errorMessage = "Произошла ошибка"
                    
                    switch error {
                    case .networkError:
                        errorMessage = "Ошибка сети. Проверьте подключение к интернету"
                    case .serverError(let message):
                        errorMessage = message
                    case .invalidURL:
                        errorMessage = "Неверный URL сервера"
                    case .noData:
                        errorMessage = "Нет данных от сервера"
                    case .decodingError:
                        errorMessage = "Ошибка обработки данных"
                    case .invalidResponse:
                        errorMessage = "Неверный ответ"
                    }
                    
                    self?.showAlert(title: "Ошибка регистрации", message: errorMessage)
                }
            }
        }
    }

    // Вспомогательный метод для показа алертов
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
    
    @objc
    private func userImageViewTapped() {
        let actionSheet = UIAlertController(title: "Выбор изображения", message: "Каким способом выбрать?", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Cделать при помощи камеры", style: .default) { [weak self] _ in
            self?.showCamera()
        }
        let galleryAction = UIAlertAction(title: "Выбрать из библиотеки", style: .default) { [weak self] _ in
            self?.showGallery()
        }
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        
        present(actionSheet, animated: true)
    }
    
    // MARK: - Private methods
    
    private func showCamera() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .camera
        pickerController.allowsEditing = true
        pickerController.delegate = self
        present(pickerController, animated: true)
    }
    
    private func showGallery() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        present(pickerController, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        
        defer {
            picker.dismiss(animated: true)
        }
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }

        mainView.userImageView.image = image
        mainView.userImageView.layer.borderWidth = 1

        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
