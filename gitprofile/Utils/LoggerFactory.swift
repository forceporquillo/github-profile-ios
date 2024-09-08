//
//  Logger.swift
//  gitprofile
//
//  Created by Aljan Porquillo on 9/8/24.
//

import Foundation

class LoggerFactory {
    
    private static var loggerInstances: [String: Logger] = [:]
    
    static func create(for className: String) -> Logger {
        if let logger = loggerInstances[className] {
            return logger
        } else {
            let logger = Logger.createLogger(for: className)
            loggerInstances[className] = logger
            return logger
        }
    }
    
    static func create(clazz: AnyClass) -> Logger {
        let className = String(describing: clazz)
        return create(for: className)
    }
    
    private init() {}
}

enum LogLevel: String {
    case debug = "DEBUG"
    case info = "INFO"
    case warn = "WARN"
    case error = "ERROR"
    case fatal = "FATAL"
}

class Logger {
    
    private let className: String
    
    private init(className: String) {
        self.className = className
    }
    
    func log(_ level: LogLevel = .debug, message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let fileName = (file as NSString).lastPathComponent
        let timestamp = ISO8601DateFormatter().string(from: Date())
        print("[\(timestamp)] [\(level.rawValue)] [\(className)] [\(fileName):\(line) \(function)] - \(message)")
    }
    
    static func createLogger(for className: String) -> Logger {
        return Logger(className: className)
    }
}
