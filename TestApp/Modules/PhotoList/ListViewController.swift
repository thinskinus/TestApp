//
//  ListViewController.swift
//  TestApp
//
//  Created by ElenaD on 11/18/18.
//  Copyright © 2018 Lena. All rights reserved.
//

import UIKit


class ListViewController: BaseViewController {

    let cellReuseIdentifier = "listCell"

    var tableView = UITableView()
    var items: [(name: String, image: UIImage)] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // create header view
        let header = UIView()
        tableView.tableHeaderView = header

        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: cellReuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension ListViewController: UITableViewDelegate {

}

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
//        cell.imageView = UIImageView(image: <#T##UIImage?#>)
        return cell
    }
}


