//
//  AppDelegate.swift
//  TestApp
//
//  Created by ElenaD on 11/18/18.
//  Copyright © 2018 Lena. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = self.window else { fatalError("No Window") }
        window.rootViewController = AuthViewController()
        window.makeKeyAndVisible()

        return true
    }
}

