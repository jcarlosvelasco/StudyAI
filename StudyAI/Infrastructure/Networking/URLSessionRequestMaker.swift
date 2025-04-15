//
//  URLSessionRequestMaker.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 15/4/25.
//

import Foundation

class URLSessionRequestMaker {
    func url(endpoint: Endpoint, baseURL: String) -> URL? {
        var urlComponents = URLComponents(string: baseURL + endpoint.path)
        let urlQueryParams = endpoint.queryParams.map {
            URLQueryItem(name: $0.key, value: "\($0.value)")
        }
        urlComponents?.queryItems = urlQueryParams
        return urlComponents?.url
    }
}
