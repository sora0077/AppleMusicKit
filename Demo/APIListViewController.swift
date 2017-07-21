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

private func csv(_ value: String) -> [String] {
    return value.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
}
private func csv(_ value: String?) -> [String]? {
    return value?.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
}
private func resouces(_ value: String?) -> Set<ResourceType>? {
    guard let arr = csv(value) else { return nil }
    return Set(arr.flatMap(ResourceType.init(rawValue:)))
}

// MARK: - APIListViewController
final class APIListViewController: UIViewController {
    private let tableView = UITableView()
    private let dataSource: [Item] = [
        Item([TextInput(name: "id", default: "jp"),
              TextInput(name: "language")]) { form in
            GetStorefront(id: form["id"], language: form["language"])
        },
        Item([TextInput(name: "ids", default: "jp"),
              TextInput(name: "language")]) { form in
            GetMultipleStorefronts(ids: csv(form["ids"]), language: form["language"])
        },
        Item([TextInput(name: "storefront", default: "us"),
              TextInput(name: "id", default: "310730204"),
              TextInput(name: "language"),
              TextInput(name: "include")]) { form in
            GetAlbum(storefront: form["storefront"],
                     id: form["id"],
                     language: form["language"],
                     include: resouces(form["include"]))
        },
        Item([TextInput(name: "storefront", default: "us"),
              TextInput(name: "id", default: "639032181"),
              TextInput(name: "language"),
              TextInput(name: "include")]) { form in
            GetMusicVideo(storefront: form["storefront"],
                          id: form["id"],
                          language: form["lamguage"],
                          include: resouces(form["include"]))
        },
        Item([TextInput(name: "storefront", default: "jp"),
              TextInput(name: "id", default: "pl.7a987d29f54b4e3e9ab15906189477f7"),
              TextInput(name: "language"),
              TextInput(name: "include")]) { form in
            GetPlaylist(storefront: form["storefront"],
                        id: form["id"],
                        language: form["lamguage"],
                        include: resouces(form["include"]))
        },
        Item([TextInput(name: "storefront", default: "us"),
              TextInput(name: "id", default: "900032829"),
              TextInput(name: "language"),
              TextInput(name: "include")]) { form in
                GetSong(storefront: form["storefront"],
                        id: form["id"],
                        language: form["lamguage"],
                        include: resouces(form["include"]))
        },
        Item([TextInput(name: "storefront", default: "us"),
              TextInput(name: "id", default: "ra.985484166"),
              TextInput(name: "language"),
              TextInput(name: "include")]) { form in
                GetStation(storefront: form["storefront"],
                           id: form["id"],
                           language: form["lamguage"],
                           include: resouces(form["include"]))
        },
        Item([TextInput(name: "storefront", default: "us"),
              TextInput(name: "ids", default: "178834,462006"),
              TextInput(name: "language"),
              TextInput(name: "include")]) { form in
                GetMultipleArtists(storefront: form["storefront"],
                                   ids: csv(form["ids"]),
                                   language: form["lamguage"],
                                   include: resouces(form["include"]))
        },
        Item([TextInput(name: "storefront", default: "us"),
              TextInput(name: "ids", default: "976439448,1107687517"),
              TextInput(name: "language"),
              TextInput(name: "include")]) { form in
                GetMultipleCurators(storefront: form["storefront"],
                                    ids: csv(form["ids"]),
                                    language: form["lamguage"],
                                    include: resouces(form["include"]))
        },
        Item([TextInput(name: "storefront", default: "us"),
              TextInput(name: "ids", default: "976439514,976439503"),
              TextInput(name: "language"),
              TextInput(name: "include")]) { form in
                GetMultipleActivities(storefront: form["storefront"],
                                      ids: csv(form["ids"]),
                                      language: form["lamguage"],
                                      include: resouces(form["include"]))
        }
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
        let cellRect = cell.convert(cell.bounds, to: navigationController?.view ?? view)
        let vc = dataSource[indexPath.row].generateFormViewController()
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
}

extension APIListViewController: APIInputFormViewControllerDelegate {
    func inputFormViewController(_ vc: APIInputFormViewController, didFinishWith request: AnyRequest) {
        for indexPath in tableView.indexPathsForSelectedRows ?? [] {
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
