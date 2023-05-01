//
//  Logger.swift
//  News
//
//  Created by Mateusz Mackowiak on 01/05/2023.
//

import Foundation

public let Log = {
#if DEBUG
    PrintLogger(level: .debug)
#else
    PrintLogger(level: .none)
#endif
}()


public protocol Logger {
    func log(_ message: @autoclosure () -> Any, type: LogLevel, file: String, function: String)
}

public extension Logger {
    func warning(_ message: @autoclosure () -> Any, file: String = #fileID, function: String = #function) {
        self.log(message(), type: .warning, file: file, function: function)
    }
    func debug(_ message: @autoclosure () -> Any, file: String = #fileID, function: String = #function) {
        self.log(message(), type: .debug, file: file, function: function)
    }
    func info(_ message: @autoclosure () -> Any, file: String = #fileID, function: String = #function) {
        self.log(message(), type: .info, file: file, function: function)
    }
}

public final class PrintLogger: Logger {
    public var level: LogLevel

    public init(level: LogLevel) {
        self.level = level
    }

    public func log(_ message: @autoclosure () -> Any, type: LogLevel, file: String = #fileID, function: String = #function) {
        if self.level.rawValue > type.rawValue {
            return
        }
        print("\(type.string)\(file).\(function)", message())
    }
}

public enum LogLevel: UInt {
    case debug = 0, info, warning, none

    fileprivate var string: String {
        switch self {
        case .none: return ""
        case .debug: return ""
        case .info: return ""
        case .warning: return "⚠️Warning: "
        }
    }
}
