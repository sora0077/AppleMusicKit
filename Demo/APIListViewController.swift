//
//  APIListViewController.swift
//  Demo
//
//  Created by 林達也 on 2017/07/19.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import AppleMusicKit

// MARK: - APIListViewController
final class APIListViewController: UIViewController {
    private typealias Form = APIInputFormViewController.Form
    private enum Section {
        case storefront([Form]), media([Form]), artist([Form]), chart([Form])
        case search([Form])

        var title: String {
            switch self {
            case .storefront: return "Fetch Storefronts"
            case .media: return "Fetch Albums, Music Videos, Playlists, Songs, and Stations"
            case .artist: return "Fetch Artists, Curators, Activities, and Apple Curators"
            case .chart: return "Fetch Charts"
            case .search: return "Search the catalog"
            }
        }
        var count: Int {
            switch self {
            case .storefront(let items), .media(let items), .artist(let items), .chart(let items),
                 .search(let items):
                return items.count
            }
        }

        subscript (idx: Int) -> Form {
            switch self {
            case .storefront(let items), .media(let items), .artist(let items), .chart(let items),
                 .search(let items):
                return items[idx]
            }
        }
    }
    private let gradientLayer = CAGradientLayer.appleMusicLayer()
    private let tableView = UITableView()
    private let dataSource: [Section] = [
        .storefront(storefrontForms),
        .media(mediaForms),
        .artist(artistForms),
        .chart(chartForms),
        .search(searchForms)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "API"
        navigationItem.largeTitleDisplayMode = .never
        view.layer.insertSublayer(gradientLayer, at: 0)

        view.addSubview(tableView)
        tableView.autolayoutFit(to: view)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
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

extension APIListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.section][indexPath.row].title
        cell.backgroundColor = .clear
        return cell
    }
}

extension APIListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        let cellRect = cell.convert(cell.bounds, to: navigationController?.view ?? view)
        let form = dataSource[indexPath.section][indexPath.row]
        let vc = APIInputFormViewController(form: form)
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = view.bounds.insetBy(dx: 20, dy: 20).size
        let popover = vc.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = view
        popover?.sourceRect = cellRect.insetBy(dx: 0, dy: -8)
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title
    }
}

extension APIListViewController: APIInputFormViewControllerDelegate {
    func inputFormViewController(_ vc: APIInputFormViewController, didFinishWithResultViewController resultVC: UIViewController) {
        for indexPath in tableView.indexPathsForSelectedRows ?? [] {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        vc.dismiss(animated: true) {
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
}

extension APIListViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        for indexPath in tableView.indexPathsForSelectedRows ?? [] {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
