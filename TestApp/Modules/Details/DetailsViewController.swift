//
//  DetailsViewController.swift
//  TestApp
//
//  Created by ElenaD on 11/21/18.
//  Copyright © 2018 Lena. All rights reserved.
//

import UIKit
import AVKit


class DetailsViewController: BaseViewController {

    var user: User?

    var photoView = UIImageView(image: UIImageView.defaultAvatarImage)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .purple

        let pickPhotoButton = UIButton(type: .system)
        pickPhotoButton.setTitle("take photo", for: .normal)
        pickPhotoButton.tintColor = .green
        pickPhotoButton.backgroundColor = .white
        pickPhotoButton.addTarget(self, action: #selector(openPhotoPicker), for: .touchUpInside)
        view.addSubview(pickPhotoButton)

        pickPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        pickPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickPhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        pickPhotoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pickPhotoButton.widthAnchor.constraint(equalToConstant: 200).isActive = true

        // current image
        if let user = user {
            if let image = user.imageLarge() {
                photoView.image = image
            } else {
                photoView.image = nil
                if let imageUrl = user.photoUrl_L {
                    photoView.downloadImageFromUrl(imageUrl, completion: { [user] image in
                        DispatchQueue.main.async { [weak self] in
                            self?.photoView.image = image
                        }
                        user.photoImage_L = image
                    })
                }
            }
        }
        view.addSubview(photoView)

        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoView.bottomAnchor.constraint(equalTo: pickPhotoButton.topAnchor, constant: -20).isActive = true
    }

    @objc func openPhotoPicker() {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == AVAuthorizationStatus.authorized {
            let picker = UIImagePickerController(nibName: nil, bundle: nil)
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                picker.delegate = self
                picker.modalPresentationStyle = .fullScreen
                picker.modalTransitionStyle = .coverVertical
                picker.cameraCaptureMode = .photo
                picker.allowsEditing = true

                self.present(picker, animated: true, completion: nil)
            }
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted == true {
                    // ok
                } else {
                    // User rejected
                    // TODO: show an alert
                }
            }
        }

    }
}

extension DetailsViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            user?.replacedImage = image
            photoView.image = image
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
