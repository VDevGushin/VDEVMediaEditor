//
//  Logger.swift
//  MediaEditor
//
//  Created by Vladislav Gushin on 25.02.2023.
//
import Foundation

/// Enum which maps an appropiate symbol which added as prefix for each log message
///
/// - error: Log type error
/// - info: Log type info
/// - debug: Log type debug
/// - verbose: Log type verbose
/// - warning: Log type warning
/// - severe: Log type severe
enum LogEvent: String {
    case e = "[‼️]" // error
    case i = "[ℹ️]" // info
    case d = "[💬]" // debug
    case v = "[🔬]" // verbose
    case w = "[⚠️]" // warning
    case s = "[🔥]" // severe
}


/// Wrapping Swift.print() within DEBUG flag
///
/// - Note: *print()* might cause [security vulnerabilities](https://codifiedsecurity.com/mobile-app-security-testing-checklist-ios/)
///
/// - Parameter object: The object which is to be logged
///
///

func externalLog(logEvent: LogEvent, object: Any) {
    if let logger = DIContainer.shared.resolveOptional(VDEVLogger.self) {
        switch logEvent {
        case .e:
            logger.e(object)
        case .i:
            logger.i(object)
        case .d:
            logger.d(object)
        case .v:
            logger.v(object)
        case .w:
            logger.w(object)
        case .s:
            logger.s(object)
        }
    }
}

func print(_ object: Any) {
    // Only allowing in DEBUG mode
    #if DEBUG
    Swift.print(object)
    #endif
}

final class Log {
    //static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormat = "hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }

    private static var isLoggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }

    // MARK: - Loging methods


    /// Logs error messages on console with prefix [‼️]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func e( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        let message = "\(Date().toString()) \(LogEvent.e.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)"
        
        externalLog(logEvent: .e, object: message)
        
        if isLoggingEnabled {
            print(message)
        }
    }

    /// Logs info messages on console with prefix [ℹ️]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func i ( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        let message = "\(Date().toString()) \(LogEvent.i.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)"
        
        externalLog(logEvent: .i, object: message)
        
        if isLoggingEnabled {
            print(message)
        }
    }

    /// Logs debug messages on console with prefix [💬]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func d( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        
        let message = "\(Date().toString()) \(LogEvent.d.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)"
        
        externalLog(logEvent: .d, object: message)
        
        if isLoggingEnabled {
            print(message)
        }
    }

    /// Logs messages verbosely on console with prefix [🔬]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func v( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        
        let message = "\(Date().toString()) \(LogEvent.v.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)"
        
        externalLog(logEvent: .v, object: message)
        
        if isLoggingEnabled {
            print(message)
        }
    }

    /// Logs warnings verbosely on console with prefix [⚠️]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func w( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        
        let message = "\(Date().toString()) \(LogEvent.w.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)"
        
        externalLog(logEvent: .w, object: message)
        
        if isLoggingEnabled {
            print(message)
        }
    }

    /// Logs severe events on console with prefix [🔥]
    ///
    /// - Parameters:
    ///   - object: Object or message to be logged
    ///   - filename: File name from where loggin to be done
    ///   - line: Line number in file from where the logging is done
    ///   - column: Column number of the log message
    ///   - funcName: Name of the function from where the logging is done
    class func s( _ object: Any, filename: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        
        let message = "\(Date().toString()) \(LogEvent.s.rawValue)[\(sourceFileName(filePath: filename))]:\(line) \(column) \(funcName) -> \(object)"
        
        externalLog(logEvent: .s, object: message)
        
        if isLoggingEnabled {
            print(message)
        }
    }


    /// Extract the file name from the file path
    ///
    /// - Parameter filePath: Full file path in bundle
    /// - Returns: File Name with extension
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

internal extension Date {
    func toString() -> String {
        return Log.dateFormatter.string(from: self as Date)
    }
}
