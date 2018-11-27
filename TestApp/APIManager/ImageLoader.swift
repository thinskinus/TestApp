//
//  ImageLoader.swift
//  TestApp
//
//  Created by ElenaD on 11/26/18.
//  Copyright © 2018 Lena. All rights reserved.
//

import Foundation
import UIKit

class ImageLoader {
    static func startDownloadTask(with url: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.dataTask(with: url,
                                   completionHandler: { (data, response, error) -> Void in
                                    guard let httpURLResponse = response as? HTTPURLResponse,
                                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                                        let data = data,
                                        let image = UIImage(data: data),
                                        error == nil,
                                        httpURLResponse.statusCode == 200
                                        else {
                                            return
                                    }
                                    completion(image)

        }).resume()
    }
}

