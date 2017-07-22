//
//  APIListViewController.swift
//  Demo
//
//  Created by 林達也 on 2017/07/19.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import AppleMusicKit

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

func inputs(storefront: String = "us", id: String) -> [FormInput] {
    return [TextInput(name: "storefront", default: storefront),
            TextInput(name: "id", default: id),
            TextInput(name: "language"),
            TextInput(name: "include")]
}

func inputs(storefront: String = "us", ids: String) -> [FormInput] {
    return [TextInput(name: "storefront", default: storefront),
            TextInput(name: "ids", default: ids),
            TextInput(name: "language"),
            TextInput(name: "include")]
}

// MARK: - APIListViewController
final class APIListViewController: UIViewController {
    private enum Section {
        case storefront([Item])
        case media([Item])
        case artist([Item])

        var title: String {
            switch self {
            case .storefront: return "Fetch Storefronts"
            case .media: return "Fetch Albums, Music Videos, Playlists, Songs, and Stations"
            case .artist: return "Fetch Artists, Curators, Activities, and Apple Curators"
            }
        }
        var count: Int {
            switch self {
            case .storefront(let items), .media(let items), .artist(let items):
                return items.count
            }
        }

        subscript (idx: Int) -> Item {
            switch self {
            case .storefront(let items), .media(let items), .artist(let items):
                return items[idx]
            }
        }
    }
    private let gradientLayer = CAGradientLayer.appleMusicLayer()
    private let tableView = UITableView()
    private let dataSource: [Section] = [
        .storefront([
            Item([TextInput(name: "id", default: "jp"), TextInput(name: "language")]) { form in
                GetStorefront(id: form["id"], language: form["language"])
            },
            Item([TextInput(name: "ids", default: "jp"), TextInput(name: "language")]) { form in
                GetMultipleStorefronts(ids: csv(form["ids"]), language: form["language"])
            }
        ]),
        .media([
            Item(inputs(id: "310730204")) { form in
                GetAlbum(storefront: form["storefront"],
                         id: form["id"],
                         language: form["language"],
                         include: resouces(form["include"]))
            },
            Item(inputs(id: "639032181")) { form in
                GetMusicVideo(storefront: form["storefront"],
                              id: form["id"],
                              language: form["lamguage"],
                              include: resouces(form["include"]))
            },
            Item(inputs(storefront: "jp", id: "pl.7a987d29f54b4e3e9ab15906189477f7")) { form in
                GetPlaylist(storefront: form["storefront"],
                            id: form["id"],
                            language: form["lamguage"],
                            include: resouces(form["include"]))
            },
            Item(inputs(id: "900032829")) { form in
                GetSong(storefront: form["storefront"],
                        id: form["id"],
                        language: form["lamguage"],
                        include: resouces(form["include"]))
            },
            Item(inputs(id: "ra.985484166")) { form in
                GetStation(storefront: form["storefront"],
                           id: form["id"],
                           language: form["lamguage"],
                           include: resouces(form["include"]))
            }
        ]),
        .artist([
            Item(inputs(ids: "178834,462006")) { form in
                GetMultipleArtists(storefront: form["storefront"],
                                   ids: csv(form["ids"]),
                                   language: form["lamguage"],
                                   include: resouces(form["include"]))
            },
            Item(inputs(ids: "976439448,1107687517")) { form in
                GetMultipleCurators(storefront: form["storefront"],
                                    ids: csv(form["ids"]),
                                    language: form["lamguage"],
                                    include: resouces(form["include"]))
            },
            Item(inputs(ids: "976439514,976439503")) { form in
                GetMultipleActivities(storefront: form["storefront"],
                                      ids: csv(form["ids"]),
                                      language: form["lamguage"],
                                      include: resouces(form["include"]))
            }
        ])
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
        let item = dataSource[indexPath.section][indexPath.row]
        let vc = APIInputFormViewController(item: item)
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
