//
//  APIResultViewController.swift
//  Demo
//
//  Created by 林達也 on 2017/07/22.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import AppleMusicKit

private extension UILayoutPriority {
    static func - (lhs: UILayoutPriority, rhs: Int) -> UILayoutPriority {
        return UILayoutPriority(lhs.rawValue - Float(rhs))
    }
}

final class APIResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private enum Section {
        case raw(String, lines: Int)
        case results([(UITableViewCell) -> Void])

        var count: Int {
            switch self {
            case .raw: return 1
            case .results(let items): return items.count
            }
        }
    }
    private let gradientLayer = CAGradientLayer.appleMusicLayer()
    private let tableView = UITableView()
    private var dataSource: [Section] = []
    private var fetcher: (_ completion: @escaping () -> Void) -> Void = { _ in }

    init<Request: AppleMusicKit.Request, A: CustomStringConvertible, R>(request: Request) where Request.Response == ResponseRoot<Resource<A, R>> {
        super.init(nibName: nil, bundle: nil)

        title = "\(Request.self)".components(separatedBy: "<").first ?? ""
        fetcher = { [weak self] completion in
            Session.shared.send(with: request) { result in
                defer {
                    completion()
                }
                let jsonString = json(from: result)
                let lines = jsonString.components(separatedBy: "\n").count
                print(jsonString, String(describing: result.error))
                switch result {
                case .success(let (response, _)):
                    self?.dataSource = [.raw(jsonString, lines: lines),
                                        .results(response.data.map { resource in
                                            let id = "\(resource.id)"
                                            var shortId = id.prefix(8)
                                            if id.count > 8 {
                                                shortId += "..."
                                            }
                                            return { cell in
                                                cell.textLabel?.text = "\(shortId) - \(resource.attributes?.description ?? "")"
                                            }
                                        })]
                case .failure:
                    self?.dataSource = [.raw(jsonString, lines: lines)]
                }
                self?.tableView.reloadData()
            }
        }
    }

    init<Request, A: CustomStringConvertible, R>(request: Request) where Request.Response == Page<Request>, Request.Resource == Resource<A, R> {
        super.init(nibName: nil, bundle: nil)

        title = "\(Request.self)".components(separatedBy: "<").first ?? ""
        fetcher = { [weak self] completion in
            Session.shared.send(with: request) { result in
                defer {
                    completion()
                }
                let jsonString = json(from: result)
                let lines = jsonString.components(separatedBy: "\n").count
                print(jsonString, String(describing: result.error))
                switch result {
                case .success(let (page, _)):
                    self?.dataSource = [.raw(jsonString, lines: lines),
                                        .results(page.data.map { resource in
                                            let id = "\(resource.id)"
                                            var shortId = id.prefix(8)
                                            if id.count > 8 {
                                                shortId += "..."
                                            }
                                            return { cell in
                                                cell.textLabel?.text = "\(shortId) - \(resource.attributes?.description ?? "")"
                                            }
                                        })]
                case .failure:
                    self?.dataSource = [.raw(jsonString, lines: lines)]
                }
                self?.tableView.reloadData()
            }
        }
    }

    init(request: GetCharts) {
        super.init(nibName: nil, bundle: nil)

        title = "\(GetCharts.self)".components(separatedBy: "<").first ?? ""
        fetcher = { [weak self] completion in
            Session.shared.send(with: request) { result in
                defer {
                    completion()
                }
                let jsonString = json(from: result)
                let lines = jsonString.components(separatedBy: "\n").count
                print(jsonString, String(describing: result.error))
                switch result {
                case .success(let (response, _)):
                    func empty(_ title: String) -> (UITableViewCell) -> Void {
                        return { cell in
                            cell.textLabel?.text = "\(title) - 0件"
                        }
                    }
                    let songs = Section.results(response.songs?.data.map { resource in { cell in
                        cell.textLabel?.text = resource.attributes?.name
                        }} ?? [empty("songs")])
                    let musicVideos = Section.results(response.musicVideos?.data.map { resource in { cell in
                        cell.textLabel?.text = resource.attributes?.name
                        }} ?? [empty("musicVideos")])
                    let albums = Section.results(response.albums?.data.map { resource in { cell in
                        cell.textLabel?.text = resource.attributes?.name
                        }} ?? [empty("albums")])
                    self?.dataSource = [.raw(jsonString, lines: lines), songs, musicVideos, albums]
                case .failure:
                    self?.dataSource = [.raw(jsonString, lines: lines)]
                }
                self?.tableView.reloadData()
            }
        }
    }

    init(request: SearchResources) {
        super.init(nibName: nil, bundle: nil)

        title = "\(SearchResources.self)".components(separatedBy: "<").first ?? ""
        fetcher = { [weak self] completion in
            Session.shared.send(with: request) { result in
                defer {
                    completion()
                }
                let jsonString = json(from: result)
                let lines = jsonString.components(separatedBy: "\n").count
                print(jsonString, String(describing: result.error))
                switch result {
                case .success(let (response, _)):
                    func empty(_ title: String) -> (UITableViewCell) -> Void {
                        return { cell in
                            cell.textLabel?.text = "\(title) - 0件"
                        }
                    }
                    let songs = Section.results(response.songs?.data.map { resource in { cell in
                        cell.textLabel?.text = resource.attributes?.name
                        }} ?? [empty("songs")])
                    let musicVideos = Section.results(response.musicVideos?.data.map { resource in { cell in
                        cell.textLabel?.text = resource.attributes?.name
                        }} ?? [empty("musicVideos")])
                    let albums = Section.results(response.albums?.data.map { resource in { cell in
                        cell.textLabel?.text = resource.attributes?.name
                        }} ?? [empty("albums")])
                    let artists = Section.results(response.artists?.data.map { resource in { cell in
                        cell.textLabel?.text = resource.attributes?.name
                        }} ?? [empty("artists")])
                    self?.dataSource = [.raw(jsonString, lines: lines), songs, musicVideos, albums, artists]
                case .failure:
                    self?.dataSource = [.raw(jsonString, lines: lines)]
                }
                self?.tableView.reloadData()
            }
        }
    }

    init(request: GetSearchHints) {
        super.init(nibName: nil, bundle: nil)

        title = "\(GetSearchHints.self)".components(separatedBy: "<").first ?? ""
        fetcher = { [weak self] completion in
            Session.shared.send(with: request) { result in
                defer {
                    completion()
                }
                let jsonString = json(from: result)
                let lines = jsonString.components(separatedBy: "\n").count
                print(jsonString, String(describing: result.error))
                switch result {
                case .success(let (response, _)):
                    let results = Section.results(response.terms.map { term in { cell in cell.textLabel?.text = term }
                    })
                    self?.dataSource = [.raw(jsonString, lines: lines), results]
                case .failure:
                    self?.dataSource = [.raw(jsonString, lines: lines)]
                }
                self?.tableView.reloadData()
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .always
        view.layer.insertSublayer(gradientLayer, at: 0)
        view.addSubview(tableView)
        tableView.autolayoutFit(to: view)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.register(RawResultCell.self, forCellReuseIdentifier: "RawResultCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicator.hidesWhenStopped = true

        indicator.startAnimating()
        fetcher {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                indicator.stopAnimating()
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch dataSource[indexPath.section] {
        case .raw(let json, let lines):
            let cell = tableView.dequeueReusableCell(withIdentifier: "RawResultCell", for: indexPath) as! RawResultCell
            cell.json = json
            cell.isScrollEnabled = lines > 100
            return cell
        case .results(let items):
            let apply = items[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            apply(cell)
            cell.textLabel?.font = UIFont.monospacedDigitSystemFont(ofSize: 14, weight: .regular)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch dataSource[indexPath.section] {
        case .raw: return 500
        case .results: return 44
        }
    }
}

extension APIResultViewController {
    private final class RawResultCell: UITableViewCell {
        private let textView = UITextView()
        var json: String {
            get { return textView.text ?? "" }
            set { textView.text = newValue }
        }
        var isScrollEnabled: Bool {
            get { return textView.isScrollEnabled }
            set { textView.isScrollEnabled = newValue }
        }

        override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            selectionStyle = .none
            backgroundColor = .clear
            contentView.addSubview(textView)
            textView.autolayoutFit(to: contentView, margin: 8)
            let height = textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
            height.priority = .required - 1
            height.isActive = true
            textView.isScrollEnabled = false
            textView.isEditable = false
            textView.backgroundColor = .clear
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
