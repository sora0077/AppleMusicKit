//
//  Session.swift
//  AppleMusicKit
//
//  Created by 林 達也 on 2017/06/27.
//  Copyright © 2017年 jp.sora0077. All rights reserved.
//

import Foundation

private extension AccessScope {
    var requireUserToken: Bool {
        switch self {
        case .user: return true
        case .readonly: return false
        }
    }
}

extension Request {

    func buildURL() throws -> URL {
        let url = baseURL.appendingPathComponent(path)
        if method != .get {
            return url
        }
        guard var comps = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw AppleMusicKitError.invalidURL(url, nil)
        }
        if let parameters = parameters, !parameters.isEmpty {
            comps.queryItems = parameters.map {
                URLQueryItem(name: $0, value: "\($1)")
            }
        }
        guard let _url = comps.url else {
            throw AppleMusicKitError.invalidURL(url, nil)
        }
        return _url
    }
}

public struct Authorization {
    public var developerToken: String
    public var musicUserToken: String?

    public init(developerToken: String, musicUserToken: String? = nil) {
        self.developerToken = developerToken
        self.musicUserToken = musicUserToken
    }
}

public func build<Req: Request, Context>(
    _ req: Req,
    authorization: Authorization?,
    using fetch: (URLRequest, @escaping (Data, HTTPURLResponse?) -> Void) -> Context,
    completion: @escaping (Result<Req.Response, Error>) -> Void
) -> Context? {
    let request: AnyRequest<Req.Response>
    let url: URL
    var urlRequest: URLRequest
    do {
        request = try AnyRequest(req, authorization: authorization)
        url = try request.buildURL()
        urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue.uppercased()
        urlRequest.allHTTPHeaderFields = request.headers
        do {
            if let parameters = request.parameters, request.method != .get {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw AppleMusicKitError.invalidURL(url, error)
        }
    } catch {
        completion(.failure(error))
        return nil
    }

    return fetch(urlRequest) { data, response in
        completion(.init(catching: {
            try request.response(from: data, urlResponse: response)
        }))
    }
}

//
//
// MARK: - private
private struct AnyRequest<R>: Request {
    typealias Response = R

    let method: HTTPMethod
    let baseURL: URL
    let path: String
    let headers: [String: String]
    let parameters: [String: Any]?

    private let response: (Data, HTTPURLResponse?) throws -> R
    fileprivate let raw: Any

    init<Req: Request>(_ request: Req, authorization: Authorization?) throws where Req.Response == R {
        response = request.response
        raw = request

        headers = try {
            var headers = request.headers
            if let developerToken = authorization?.developerToken {
                headers["Authorization"] = "Bearer \(developerToken)"
            } else {
                throw AppleMusicKitError.missingDeveloperToken
            }
            if let musicUserToken = authorization?.musicUserToken {
                headers["Music-User-Token"] = musicUserToken
            } else if request.scope.requireUserToken {
                throw AppleMusicKitError.missingMusicUserToken
            }
            return headers
        }()
        method = request.method
        baseURL = request.baseURL
        path = request.path
        parameters = request.parameters
    }

    func response(from data: Data, urlResponse: HTTPURLResponse?) throws -> R {
        return try response(data, urlResponse)
    }
}
