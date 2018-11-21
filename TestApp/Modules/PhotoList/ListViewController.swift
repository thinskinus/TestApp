//
//  ListViewController.swift
//  TestApp
//
//  Created by ElenaD on 11/18/18.
//  Copyright © 2018 Lena. All rights reserved.
//

import UIKit

class ListHeaderView: UIView {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
}

class ListViewController: BaseViewController {

    let cellReuseIdentifier = "listCell"

    @IBOutlet weak var tableView: UITableView!

    var topUser: User? {
        didSet {
            updateHeader()
        }
    }
    var users: [User] = [] {
        didSet {
            updateList()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateHeader()

        // refresh control
        tableView.refreshControl = UIRefreshControl(frame: .zero)
        tableView.refreshControl?.addTarget(self, action: #selector(refreshList), for: UIControl.Event.valueChanged)
    }

    func updateHeader() {
        if let header = tableView.tableHeaderView as? ListHeaderView,
            let topUser = topUser {
            header.usernameLabel.text = topUser.displayName()
            if let image = topUser.imageSmall() {
                header.userAvatar.image = image
            } else {
                if let imageUrl = topUser.photoUrl_S {
                    header.userAvatar.downloadImageFromUrl(imageUrl, completion: { image in
                        topUser.photoImage_S = image
                    })
                }
            }
        }
    }

    func updateList() {
        tableView.reloadData()
    }

    @objc func refreshList() {
        coordinator?.reloadList { [weak self] friends in
            self?.users = friends
            self?.updateList()
            self?.tableView.refreshControl?.endRefreshing()
        }
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        coordinator?.openDetails(for:users[indexPath.row])
    }
}

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let i = indexPath.row
        let user = users[i]
        if let image = user.imageSmall() {
            cell.imageView?.image = image
        } else {
            cell.imageView?.image = nil
            if let imageUrl = user.photoUrl_S {
                cell.imageView?.downloadImageFromUrl(imageUrl, completion: { image in
                    DispatchQueue.main.async {
                        cell.imageView?.image = image
                    }
                    user.photoImage_S = image
                })
            }
        }
        cell.textLabel?.text = users[i].displayName()
        return cell
    }
}

extension ListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for i in indexPaths.map({ $0.row }) {
            let user = users[i]
            if user.imageSmall() == nil {
                if let imageUrl = user.photoUrl_S {
                    APIManager.shared.startDownloadTask(with: imageUrl, completion: { image in
                        user.photoImage_S = image
                    })
                }
            }
        }
    }
}
