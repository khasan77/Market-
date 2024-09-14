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
        
        self.navigationController?.dismiss(animated: true)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
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
