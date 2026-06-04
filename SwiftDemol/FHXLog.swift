//
//  FHXLog.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/4.
//

import Foundation

// 日志等级：
enum FHXLogLevel {
    case debug
    case info
    case warning
    case error
}

struct FHXLogModel {

    let message: String

    let level: FHXLogLevel

    let time: Date

    let file: String

    let function: String

    let line: Int
}

class FHXLog {
    
    private static var store = FHXLogStore()

    static func info(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            message,
            level: .info,
            file: file,
            function: function,
            line: line
        )
    }
    
    static func debug(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            message,
            level: .debug,
            file: file,
            function: function,
            line: line
        )
    }
    
    static func error(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(
            message,
            level: .error,
            file: file,
            function: function,
            line: line
        )
    }
    
    static func allLogs() -> [FHXLogModel] {
        return store.all()
    }

    private static func log(
        _ message: String,
        level: FHXLogLevel,
        file: String,
        function: String,
        line: Int
    ) {

        let fileName = URL(fileURLWithPath: file)
            .deletingPathExtension()
            .lastPathComponent

        let model = FHXLogModel(
            message: message,
            level: level,
            time: Date(),
            file: fileName,
            function: function,
            line: line
        )

        store.append(model)

        print(
            "[\(level)] " +
            "\(fileName)." +
            "\(function):" +
            "[\(line)] " +
            "\(message)"
        )
    }
}

