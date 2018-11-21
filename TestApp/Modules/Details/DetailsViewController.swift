//
//  DetailsViewController.swift
//  TestApp
//
//  Created by ElenaD on 11/21/18.
//  Copyright © 2018 Lena. All rights reserved.
//

import UIKit

class DetailsViewController: BaseViewController {

    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        let pickPhotoButton = UIButton(type: .system)
        pickPhotoButton.setTitle("select photo", for: .normal)
        pickPhotoButton.tintColor = .green
        pickPhotoButton.backgroundColor = .white
        pickPhotoButton.addTarget(self, action: #selector(openPhotoPicker), for: .touchUpInside)
        view.addSubview(pickPhotoButton)

        pickPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        pickPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickPhotoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
        pickPhotoButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        pickPhotoButton.widthAnchor.constraint(equalToConstant: 200).isActive = true

        // current image
        let photoView = UIImageView(image: UIImageView.defaultAvatarImage)
        if let user = user {
            if let image = user.smallPhotoImage {
                photoView.image = image
            } else {
                photoView.image = nil
                if let imageUrl = user.smallPhotoUrl {
                    photoView.downloadImageFromUrl(imageUrl, completion: { [user] image in
                        DispatchQueue.main.async { [photoView] in
                            photoView.image = image
                        }
                        user.smallPhotoImage = image
                    })
                }
            }
        }
        view.addSubview(photoView)

        photoView.translatesAutoresizingMaskIntoConstraints = false
        photoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoView.bottomAnchor.constraint(equalTo: pickPhotoButton.topAnchor, constant: -20).isActive = true
        photoView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        photoView.widthAnchor.constraint(equalToConstant: 200).isActive = true


    }

    @objc func openPhotoPicker() {

    }
}
