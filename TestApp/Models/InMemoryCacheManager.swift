//
//  InMemoryCacheManager.swift
//  TestApp
//
//  Created by ElenaD on 11/20/18.
//  Copyright © 2018 Lena. All rights reserved.
//

import Foundation

class InMemoryCacheManager {
    var authorizedUser: User?
    var friends: [User] = []

    func clear() {
        authorizedUser = nil
        friends = []
    }
}

