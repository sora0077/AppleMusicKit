//
//  TopViewController.swift
//  Demo
//
//  Created by 林 達也 on 2017/07/18.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import SafariServices

extension UIView {
    func autolayoutFit(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}

extension CAGradientLayer {
    static func appleMusicLayer() -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.colors = [
            UIColor(hex: 0xF6DCD9).cgColor,
            UIColor(hex: 0xd4d2fa).cgColor]
        layer.startPoint = .zero
        layer.endPoint = CGPoint(x: 1, y: 1)
        return layer
    }
}

final class TopViewController: UIViewController {
    private enum Item {
        case deviceToken, document, request

        var title: String {
            switch self {
            case .deviceToken: return "Set DeviceToken"
            case .request: return "Call API"
            case .document: return "MusicKit - Apple Developer"
            }
        }
    }
    private let gradientLayer = CAGradientLayer.appleMusicLayer()
    private let tableView = UITableView()
    private let dataSource = [
        Item.deviceToken, .request, .document
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "AppleMusicKit"
        navigationController?.navigationBar.prefersLargeTitles = true

        view.layer.insertSublayer(gradientLayer, at: 0)

        view.addSubview(tableView)
        tableView.autolayoutFit(to: view)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for indexPath in tableView.indexPathsForSelectedRows ?? [] {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
}

extension TopViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row].title
        cell.backgroundColor = .clear
        return cell
    }
}

extension TopViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch dataSource[indexPath.row] {
        case .deviceToken:
            navigationController?.pushViewController(DeviceTokenInputViewController(), animated: true)
        case .request:
            break
        case .document:
            let vc = SafariViewController(url: URL(string: "https://developer.apple.com/musickit/")!)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - SafariViewController
final class SafariViewController: SFSafariViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
    }
}