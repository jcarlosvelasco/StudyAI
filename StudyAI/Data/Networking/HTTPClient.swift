//
//  HTTPClient.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 15/4/25.
//

import Foundation

protocol HTTPClient {
    func makeRequest(endpoint: Endpoint, baseUrl: String) async -> Result<Data, HTTPClientError>
}
