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
    var nameLabel = UILabel()

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
        pickPhotoButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        pickPhotoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pickPhotoButton.widthAnchor.constraint(equalToConstant: 200).isActive = true

        // current image
        if let user = user {
            if let image = user.imageLarge() {
                photoView.image = image
            } else {
                photoView.image = nil
                if let imageUrl = user.photoUrl_L {
                    photoView.downloadImageFromUrl(imageUrl) { image in
                        user.photoImage_L = image
                    }
                }
            }
        }
        view.addSubview(photoView)

        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.contentMode = .scaleAspectFit
        photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoView.bottomAnchor.constraint(equalTo: pickPhotoButton.topAnchor, constant: -20).isActive = true
        photoView.widthAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        photoView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true

        // current name
        nameLabel.text = user?.displayName()
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0
        view.addSubview(nameLabel)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
    }

    @objc func openPhotoPicker() {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == AVAuthorizationStatus.authorized {
            let picker = UIImagePickerController()
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true

                show(picker, sender: nil)
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
        if let image = info[.editedImage] as? UIImage {
            // update in-memory cache
            user?.replacingImage = image
            // update current image on screen
            photoView.image = image
            photoView.setNeedsLayout()
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
