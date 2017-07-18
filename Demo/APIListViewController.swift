//
//  APIListViewController.swift
//  Demo
//
//  Created by 林達也 on 2017/07/19.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import UIKit
import AppleMusicKit
import APIKit

private struct AnyRequest: AppleMusicKit.Request {
    typealias Response = Any

    let method: HTTPMethod
    let baseURL: URL
    let path: String
    let dataParser: DataParser
    let headerFields: [String : String]
    let parameters: Any?
    let queryParameters: [String : Any]?
    let bodyParameters: BodyParameters?
    let scope: AccessScope

    private let interceptRequest: (URLRequest) throws -> URLRequest
    private let interceptObject: (Any, HTTPURLResponse) throws -> Any
    private let response: (Any, HTTPURLResponse) throws -> Response
    let raw: Any

    init<Req: AppleMusicKit.Request>(_ request: Req) {
        interceptRequest = request.intercept(urlRequest:)
        interceptObject = request.intercept(object:urlResponse:)
        response = request.response
        raw = request

        headerFields = request.headerFields
        method = request.method
        baseURL = request.baseURL
        path = request.path
        dataParser = request.dataParser
        parameters = request.parameters
        queryParameters = request.queryParameters
        bodyParameters = request.bodyParameters
        scope = request.scope
    }

    func intercept(urlRequest: URLRequest) throws -> URLRequest {
        return try interceptRequest(urlRequest)
    }

    func intercept(object: Any, urlResponse: HTTPURLResponse) throws -> Any {
        return try interceptObject(object, urlResponse)
    }

    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        return try response(object, urlResponse)
    }
}

final class APIListViewController: UIViewController {
    private let tableView = UITableView()
    private let dataSource: [AnyRequest] = [
        AnyRequest(GetStorefront(id: "jp")),
        AnyRequest(GetMultipleStorefronts(id: "jp", "us"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(tableView)
        tableView.autolayoutFit(to: view)

        tableView.delegate = self
        tableView.dataSource = self
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
        cell.textLabel?.text = "\(dataSource[indexPath.row].raw)".components(separatedBy: "<").first
        return cell
    }
}

extension APIListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Session.shared.send(dataSource[indexPath.row]) { result in
            tableView.deselectRow(at: indexPath, animated: true)
            print(result)
        }
    }
}
