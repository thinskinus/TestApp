//
//  User.swift
//  TestApp
//
//  Created by ElenaD on 11/18/18.
//  Copyright © 2018 Lena. All rights reserved.
//

import Foundation
import UIKit

class User {
    var id: Int?
    var firstname: String?
    var lastname: String?
    var photoId: String?
    var photoUrl_S: String?
    var photoImage_S: UIImage?
    var photoUrl_L: String?
    var photoImage_L: UIImage?
    var replacingImage: UIImage?

    required init(from json: [String: Any]) {
        id = json["id"] as? Int
        firstname = json["first_name"] as? String
        lastname = json["last_name"] as? String
        photoId = json["photo_id"] as? String
        photoUrl_S = json["photo_50"] as? String
        photoUrl_L = json["photo_200_orig"] as? String
    }

    func displayName() -> String {
        var names: [String] = []
        if let firstname = firstname {
            names.append(firstname)
        }
        if let lastname = lastname {
            names.append(lastname)
        }
        if names.isEmpty {
            if let id = id {
                names.append("\(id)")
            } else {
                names.append("unknown user")
            }
        }
        return names.joined(separator: " ")
    }

    func imageSmall() -> UIImage? {
        return replacingImage ?? photoImage_S
    }

    func imageLarge() -> UIImage? {
        return replacingImage ?? photoImage_L
    }
}
