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

public struct Authorization {
    public var developerToken: String
    public var musicUserToken: String?

    public init(developerToken: String, musicUserToken: String? = nil) {
        self.developerToken = developerToken
        self.musicUserToken = musicUserToken
    }
}

public func build<Req: Request>(
    _ req: Req,
    authorization: Authorization?,
    fetch: (URLRequest, @escaping (Data, HTTPURLResponse?) -> Void) -> Void,
    completion: @escaping (() throws -> Req.Response) -> Void
) {
    let request: AnyRequest<Req.Response>
    let body: Data?
    do {
        request = try AnyRequest(req, authorization: authorization)
        if let parameters = request.parameters, request.method != .get {
            body = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } else {
            body = nil
        }
    } catch {
        completion {
            throw error
        }
        return
    }
    let url = request.baseURL.appendingPathComponent(request.path)
    guard var comps = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
        completion {
            throw AppleMusicKitError.invalidURL(url)
        }
        return
    }
    if let parameters = request.parameters, !parameters.isEmpty, request.method == .get {
        comps.queryItems = parameters.map {
            URLQueryItem(name: $0, value: "\($1)")
        }
    }
    guard let _url = comps.url else {
        completion {
            throw AppleMusicKitError.invalidURL(url)
        }
        return
    }

    var urlRequest = URLRequest(url: _url)
    urlRequest.httpMethod = request.method.rawValue.uppercased()
    urlRequest.httpBody = body
    urlRequest.allHTTPHeaderFields = request.headers
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")

    fetch(urlRequest) { data, response in
        completion {
            return try request.response(from: data, urlResponse: response)
        }
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
