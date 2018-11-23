//
//  AppCoordinator.swift
//  TestApp
//
//  Created by ElenaD on 11/18/18.
//  Copyright © 2018 Lena. All rights reserved.
//

import Foundation
import UIKit
import AVKit

protocol Coordinator: class {
    var navigationController: UINavigationController? { get set }

    func start()
    func showList()
    func reloadList(completion: @escaping ([User]) -> Void)
    func openDetails(for user: User)
}

/// Common coordinator for all VC transitions
class AppCoordinator: Coordinator {

    weak var window: UIWindow?
    var apiManager: (AuthDelegate & DataLoader)!

    var navigationController: UINavigationController?

    init(with window: UIWindow?, apiManager: (AuthDelegate & DataLoader)) {
        self.window = window
        self.apiManager = apiManager
    }

    /// Start presenting
    @objc func start() {
        if let vc = initialVC() {
            makeRoot(vc)
        }
    }

    /// Initial app's VC is defined here
    private func initialVC() -> UIViewController? {
        let vc = AuthViewController()
        vc.coordinator = self
        vc.authDelegate = apiManager
        return vc
    }

    func showList() {
        guard let vc = UIStoryboard(name: "ListViewController", bundle: nil).instantiateInitialViewController() as? ListViewController else {
            return
        }
        vc.coordinator = self

        apiManager.requestUserData { user, friends in
            vc.topUser = user
            vc.users = friends
        }

        navigationController = UINavigationController(rootViewController: vc)
        let exitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.stop,
                                         target: self,
                                         action: #selector(logout))
        navigationController?.navigationBar.topItem?.rightBarButtonItem = exitButton

        makeRoot(navigationController)
    }

    func reloadList(completion: @escaping ([User]) -> Void) {
        apiManager.requestList { _, friends in
            completion(friends)
        }
    }

    func openDetails(for user: User) {
        let vc = DetailsViewController()
        vc.user = user
        goTo(vc: vc)
    }

    // MARK: - private
    private func goTo(vc: UIViewController) {
        if let navigationController = navigationController {
            navigationController.pushViewController(vc, animated: false)
        } else {
            makeRoot(vc)
        }
    }

    private func makeRoot(_ vc: UIViewController?) {
        window?.rootViewController = vc
    }

    @objc private func logout() {
        apiManager.logout()

        if let vc = initialVC() {
            navigationController = nil
            makeRoot(vc)
        }
    }
}

