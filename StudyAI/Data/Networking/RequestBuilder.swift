//
//  RequestBuilder.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 15/4/25.
//

class RequestBuilder {
    func buildRequest(model: String, text: String) -> [String: Any] {
        return [
            "model": model,
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "text",
                            "text": text
                        ]
                    ]
                ]
            ]
        ]
    }
}
