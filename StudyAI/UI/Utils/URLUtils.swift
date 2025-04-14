//
//  URLUtils.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 6/4/25.
//

import Foundation

extension URL {
    func shortDisplayPath(keepLastComponents count: Int = 2) -> String {
        let components = self.pathComponents.suffix(count)
        return components.joined(separator: "/")
    }
}
