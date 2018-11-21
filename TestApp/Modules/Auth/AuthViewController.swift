//
//  AuthViewController.swift
//  TestApp
//
//  Created by ElenaD on 11/18/18.
//  Copyright © 2018 Lena. All rights reserved.
//

import UIKit
import VKSdkFramework

class AuthViewController: BaseViewController {

    weak var authDelegate: AuthDelegate?

    var errorMessageLabel: UILabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Login", for: .normal)
        loginButton.tintColor = .green
        loginButton.backgroundColor = .white
        loginButton.addTarget(self, action: #selector(startAuth), for: .touchUpInside)
        view.addSubview(loginButton)

        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true

        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.textAlignment = .center
        view.addSubview(errorMessageLabel)
        errorMessageLabel.textColor = .white
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        errorMessageLabel.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -10).isActive = true
        errorMessageLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true

        VKSdk.forceLogout()
    }

    @objc private func startAuth() {
        // VKsdk for auth
        if let vksdk = VKSdk.initialize(withAppId: "6755193") {
            vksdk.register(self)
            vksdk.uiDelegate = self
        }

        let vkScope = ["friends"]

        VKSdk.authorize(vkScope)
    }
}

extension AuthViewController: VKSdkDelegate {
    func vkSdkUserAuthorizationFailed() {
        // TODO: error handling
        print("Auth failed")
    }

    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        errorMessageLabel.text = nil
        if let error = result.error {
            errorMessageLabel.text = error.localizedDescription
        }
        if let token = result.token {
            authDelegate?.keepToken(token)
            coordinator?.showList()
        }
    }
}


extension AuthViewController: VKSdkUIDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        if (self.presentedViewController != nil) {
            self.dismiss(animated: true, completion: {
                self.present(controller, animated: true, completion: nil)
            })
        } else {
            self.present(controller, animated: true, completion: nil)
        }
    }

    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        if let vc = VKCaptchaViewController.captchaControllerWithError(captchaError) {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
