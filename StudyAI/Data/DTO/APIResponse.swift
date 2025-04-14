//
//  ModelResponse.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 3/4/25.
//

import Foundation

struct APIResponse: Codable {
    let id: String
    let provider: String
    let model: String
    let object: String
    let created: Int
    let choices: [Choice]
    let usage: Usage
}

struct Choice: Codable {
    let logprobs: String?
    let finishReason: String
    let nativeFinishReason: String
    let index: Int
    let message: Message
}

struct Message: Codable {
    let role: String
    let content: String
    let refusal: String?
}

struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

extension Choice {
    enum CodingKeys: String, CodingKey {
        case logprobs
        case finishReason = "finish_reason"
        case nativeFinishReason = "native_finish_reason"
        case index
        case message
    }
}

extension Message {
    enum CodingKeys: String, CodingKey {
        case role
        case content
        case refusal
    }
}
