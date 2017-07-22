//
//  APIResultViewController.swift
//  Demo
//
//  Created by 林達也 on 2017/07/22.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit

private extension UILayoutPriority {
    static func - (lhs: UILayoutPriority, rhs: Int) -> UILayoutPriority {
        return UILayoutPriority(lhs.rawValue - Float(rhs))
    }
}

final class APIResultViewController: UIViewController {
    private enum Section {
        case raw(String, lines: Int)
        case results([Any])

        var count: Int {
            switch self {
            case .raw: return 1
            case .results(let items): return items.count
            }
        }
    }
    private let gradientLayer = CAGradientLayer.appleMusicLayer()
    private let tableView = UITableView()
    private let request: AnyRequest
    private var dataSource: [Section] = []

    init(request: AnyRequest) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        Session.shared.send(with: request) { [weak self] result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                indicator.stopAnimating()
            }
            let jsonString = json(from: result)
            let lines = jsonString.components(separatedBy: "\n").count
            print(jsonString)
            switch result {
            case .success(_):
                self?.dataSource = [.raw(jsonString, lines: lines)]
            case .failure:
                self?.dataSource = [.raw(jsonString, lines: lines)]
            }
            self?.tableView.reloadData()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
}

extension APIResultViewController: UITableViewDataSource {
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            return cell
        }
    }
}

extension APIResultViewController: UITableViewDelegate {
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
            height.priority = UILayoutPriority.required - 1
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
