//
//  Logger.swift
//  StudyAI
//
//  Created by Juan Carlos Velasco on 15/4/25.
//

import Foundation

class Logger {
    enum LogLevel: String {
        case info = "ℹ️"
        case warning = "⚠️"
        case error = "❌"
    }
    
    static func log(_ level: LogLevel,
             _ message: @autoclosure () -> String,
             file: String = #file,
             function: String = #function,
             line: Int = #line) {
        #if DEBUG
            let filename = (file as NSString).lastPathComponent
            print("\(level.rawValue) [\(filename):\(line)] \(function): \(message())")
        #endif
    }
}
