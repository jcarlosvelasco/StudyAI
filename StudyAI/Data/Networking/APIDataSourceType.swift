//
//  APIDataSourceType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 15/4/25.
//

protocol APIDataSourceType {
    func sendMessageToLLM(text: String) async -> Result<APIResponse, HTTPClientError>
}
