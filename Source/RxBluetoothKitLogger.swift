import Foundation

/// Namespace for assigning the default logger.
public enum RxBluetoothKitLogger {
    /// The default logger that will be used by RxBluetoothKit
    public static var defaultLogger: Logger = SimplePrintLogger()
}

public class SimplePrintLogger: Logger {

    public var logMessage: ((() -> String,
                            RxBluetoothKitLog.LogLevel,
                            String,
                            String,
                            UInt) -> ())? = nil
    private var currentLogLevel: RxBluetoothKitLog.LogLevel = .verbose

    /// Set new log level.
    /// - Parameter logLevel: New log level to be applied.
    public func setLogLevel(_ logLevel: RxBluetoothKitLog.LogLevel) {
        self.currentLogLevel = logLevel
    }

    /// Get current log level.
    /// - Returns: Currently set log level.
    public func getLogLevel() -> RxBluetoothKitLog.LogLevel {
        return currentLogLevel
    }

    public func log(
        _ message: @autoclosure () -> String,
        level: RxBluetoothKitLog.LogLevel,
        file: StaticString,
        function: StaticString,
        line: UInt
    ) {
        log(
            message() + " file: \(file) function: \(function) line: \(line)",
            level: level,
            file: String(describing: file),
            function: String(describing: function),
            line: line
        )
    }

    public func log(
        _ message: @autoclosure () -> String,
        level: RxBluetoothKitLog.LogLevel,
        file: String,
        function: String,
        line: UInt
    ) {
        if currentLogLevel <= level {
            print("\(tag(with: level)) \(message())")
            if let logMessage = self.logMessage {
                logMessage(message, level, file, function, line)
            }
        }
    }

    fileprivate func tag(with logLevel: RxBluetoothKitLog.LogLevel) -> String {
        let prefix: String

        switch logLevel {
        case .none:
            prefix = "[RxBLEKit|NONE|"
        case .verbose:
            prefix = "[RxBLEKit|VERB|"
        case .debug:
            prefix = "[RxBLEKit|DEBG|"
        case .info:
            prefix = "[RxBLEKit|INFO|"
        case .warning:
            prefix = "[RxBLEKit|WARN|"
        case .error:
            prefix = "[RxBLEKit|ERRO|"
        }
        let time = Date().timeIntervalSinceReferenceDate

        return prefix + String(
            format: "%02.0f:%02.0f:%02.0f.%03.f]:",
            floor(time / 3600.0).truncatingRemainder(dividingBy: 24),
            floor(time / 60.0).truncatingRemainder(dividingBy: 60),
            floor(time).truncatingRemainder(dividingBy: 60),
            floor(time * 1000).truncatingRemainder(dividingBy: 1000)
        )
    }
}
