//
//  APIListViewController.swift
//  Demo
//
//  Created by 林達也 on 2017/07/19.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import AppleMusicKit

private struct Item {
    let title: String
    private let viewControllerTemplate: () -> APIInputFormViewController

    init<Req: Request>(_ inputs: [FormInput],
                       _ request: @escaping (APIInputFormViewController.Form) -> Req) {
        self.title = "\(Req.self)".components(separatedBy: "<").first ?? ""
        viewControllerTemplate = {
            APIInputFormViewController(inputs: inputs, request: { AnyRequest(request($0)) })
        }
    }

    func generateFormViewController() -> APIInputFormViewController {
        return viewControllerTemplate()
    }
}

// MARK: - APIListViewController
final class APIListViewController: UIViewController {
    private let tableView = UITableView()
    private let dataSource: [Item] = [
        Item([TextInput(name: "id", default: "jp"),
              TextInput(name: "language", default: nil)]) { form in
            GetStorefront(id: form["id"], language: form["language"])
        }
//        AnyRequest(GetStorefront(id: "jp")),
//        AnyRequest(GetMultipleStorefronts(id: "jp", "us")),
//        AnyRequest(GetAlbum(storefront: "us", id: "310730204"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(tableView)
        tableView.autolayoutFit(to: view)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        for indexPath in tableView.indexPathsForSelectedRows ?? [] {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
}

extension APIListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row].title
        return cell
    }
}

extension APIListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        let vc = dataSource[indexPath.row].generateFormViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = view.bounds.insetBy(dx: 20, dy: 20).size
        let popover = vc.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = cell
        popover?.sourceRect = cell.convert(cell.bounds, to: tableView)
        present(vc, animated: true, completion: nil)
    }
}

extension APIListViewController: APIInputFormViewControllerDelegate {
    func inputFormViewController(_ vc: APIInputFormViewController, didFinishWith request: AnyRequest) {
        vc.dismiss(animated: true) {
            Session.shared.send(request) { result in
                print(result)
            }
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
