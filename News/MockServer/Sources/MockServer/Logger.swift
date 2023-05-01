import Foundation

public enum LogLevel: UInt {
    case verbose = 0, debug, info, warning, error

    public var string: String {
        switch self {
        case .verbose: return "Verbose"
        case .debug: return "Debug"
        case .info: return "Info"
        case .warning: return "Warning"
        case .error: return "Error"
        }
    }
}

public class PrintLogger: Logger {
    public var level: LogLevel
    let symbols: [LogLevel: String]

    public init(level: LogLevel = .verbose, symbols: [LogLevel: String] = [.warning: "⚠️", .error: "‼️"]) {
        self.level = level
        self.symbols = symbols
    }

    public func log(_ message: String, type: LogLevel, file: String = #file, function: String = #function, line: Int = #line) {
        guard self.level.rawValue >= level.rawValue else {
            return
        }
        let file = file.split(separator: "/").last.map(String.init) ?? file
        let message = "\(file): \(message)"
        print(symbols[type].flatMap { $0 + message } ?? message)
    }
}

public protocol Logger {
    func log(_ message: String, type: LogLevel, file: String, function: String, line: Int)
}

public extension Logger {
    func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        self.log(message, type: .warning, file: file, function: function, line: line)
    }

    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        self.log(message, type: .error, file: file, function: function, line: line)
    }

    func verbose(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        self.log(message, type: .verbose, file: file, function: function, line: line)
    }

    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        self.log(message, type: .info, file: file, function: function, line: line)
    }

    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        self.log(message, type: .debug, file: file, function: function, line: line)
    }
}
