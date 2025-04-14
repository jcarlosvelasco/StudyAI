//
//  LLMInfrastructureType.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 27/3/25.
//


protocol LLMInfrastructureType {
    func sendMessage(text: String) async -> APIResponse?
    func sendText(text: String) async -> APIResponse?
}
