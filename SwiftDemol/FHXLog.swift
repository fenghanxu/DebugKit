//
//  FHXLog.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/4.
//

import Foundation

// 日志等级：
enum FHXLogLevel: Int {
    case debug = 0
    case info
    case warning
    case error
}

struct FHXLogModel {
    // 日志内容
    let message: String
    // 日志等级
    let level: FHXLogLevel
    // 触发时间
    let time: Date
    //文件名称
    let file: String
    //方法名称
    let function: String
    // 行数
    let line: Int
}

class FHXLog {

    // MARK: - singleton
    static let shared = FHXLog()
    private init() {}

    // MARK: - storage
    private let store = FHXLogStore()

    // MARK: - config（来自 SPLogs 思想）
    
    /// 总开关
    var isEnabled: Bool = true

    /// 最大日志数量
    var maxCount: Int = 1000

    /// 输出等级控制
    var logLevel: FHXLogLevel = .debug

    // MARK: - MARK: logging core

    func info(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .info, file: file, function: function, line: line)
    }

    func debug(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .debug, file: file, function: function, line: line)
    }

    func warning(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .warning, file: file, function: function, line: line)
    }

    func error(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(message, level: .error, file: file, function: function, line: line)
    }

}

extension FHXLog {

    func allLogs() -> [FHXLogModel] {
        store.all()
    }

    func clear() {
        store.clear()
    }
}

private extension FHXLog {

    func log(
        _ message: String,
        level: FHXLogLevel,
        file: String,
        function: String,
        line: Int
    ) {

        // ❌ 总开关
        guard isEnabled else { return }

        // ❌ 等级过滤（SPLogs 没有，但我们加）
        guard level.rawValue >= logLevel.rawValue else { return }

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

        // 存储
        store.append(model, maxCount: maxCount)

        // 控制台输出
        print(
            "[\(level)] " +
            "\(fileName)." +
            "\(function):[\(line)] " +
            "\(message)"
        )
    }
}
