//
//  Endpoint.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 15/4/25.
//

import Foundation

struct Endpoint {
    let path: String
    let queryParams: [String: Any]
    let method: HTTPMethod
    let headers: [String: String]
    let body: Data?
    
    init(
        path: String,
        queryParams: [String : Any] = [:],
        method: HTTPMethod,
        headers: [String : String] = [:],
        body: Data?
    ) {
        self.path = path
        self.queryParams = queryParams
        self.method = method
        self.headers = headers
        self.body = body
    }
}
