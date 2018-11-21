//
//  InMemoryCacheManager.swift
//  TestApp
//
//  Created by ElenaD on 11/20/18.
//  Copyright © 2018 Lena. All rights reserved.
//

import Foundation

class InMemoryCacheManager {

    static let shared = InMemoryCacheManager()
    private init() {}

    var authorizedUser: User?
    var friends: [User] = []
}

