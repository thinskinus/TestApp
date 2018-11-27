//
//  UIImageView+downloadTask.swift
//  TestApp
//
//  Created by ElenaD on 11/20/18.
//  Copyright © 2018 Lena. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    static let defaultAvatarImage: UIImage = #imageLiteral(resourceName: "vkPlaceholder")

    func downloadImageFromUrl(_ url: String,
                              defaultImage: UIImage? = UIImageView.defaultAvatarImage,
                              completion: @escaping (UIImage) -> Void) {
        image = defaultImage
        ImageLoader.startDownloadTask(with: url) { [weak self] image in
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
            completion(image)
        }
    }
}
