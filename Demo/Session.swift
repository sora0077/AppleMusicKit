//
//  Session.swift
//  Demo
//
//  Created by 林達也 on 2017/07/22.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import AppleMusicKit

enum Result<Value, Error> {
    case success(Value)
    case failure(Error)

    var error: Error? {
        switch self {
        case .failure(let error): return error
        case .success: return nil
        }
    }
}

func json<Res>(from result: Result<(response: Res, json: String), Error>) -> String {
    switch result {
    case .success(let response): return response.json
    case .failure(let error): return error.json ?? ""
    }
}

enum Error: Swift.Error {
    case api(Errors, json: String)
    case error(Swift.Error)

    var json: String? {
        switch self {
        case .api(_, let json): return json
        case .error: return nil
        }
    }
}

private struct APIError: Swift.Error {
    let errors: Errors
    let data: Any
}

class Session {

    static let shared = Session()

    var authorization: Authorization?

    func send<Request: AppleMusicKit.Request>(
        with request: Request,
        handler: @escaping (Result<(response: Request.Response, json: String), Demo.Error>) -> Void
    ) {
        let _handler: (Result<(response: Request.Response, json: String), Demo.Error>) -> Void = { result in
            DispatchQueue.main.async {
                handler(result)
            }
        }
        func fetch(urlRequest: URLRequest, completion: @escaping (Data, HTTPURLResponse?) -> Void) {
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    _handler(.failure(Error.error(error)))
                } else {
                    completion(data!, response as? HTTPURLResponse)
                }
            }
            task.resume()
        }
        build(AnyRequest(request), authorization: authorization, fetch: fetch) { response in
            do {
                let (response, data) = try response()
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let pp = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                let jsonString = String(data: pp, encoding: .utf8)?.replacingOccurrences(of: "\\", with: "")

                _handler(.success((response, jsonString ?? "")))
            } catch {
                _handler(.failure(Error.error(error)))
            }
        }
    }
}
