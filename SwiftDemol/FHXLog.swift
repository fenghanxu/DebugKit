//
//  FHXLog.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/4.
//

import Foundation

// 日志等级：
enum FHXLogType: Int {
    case debug = 0 // 日志
    case network   // 网络
    case error     // 错误
    case crash     // 崩溃
}

struct FHXLogModel {
    // 日志内容
    let message: String
    // 日志等级
    let level: FHXLogType
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
    var logLevel: FHXLogType = .debug

    // MARK: - MARK: logging core
    
    func log(
        _ message: Any,
        _ level: FHXLogType = .debug,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {

        saveLog(
            String(describing: message),
            level: level,
            file: file,
            function: function,
            line: line
        )
    }

    func network(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        saveLog(message, level: .network, file: file, function: function, line: line)
    }

    func debug(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        saveLog(message, level: .debug, file: file, function: function, line: line)
    }

    func warning(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        saveLog(message, level: .crash, file: file, function: function, line: line)
    }

    func error(
        _ message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        saveLog(message, level: .error, file: file, function: function, line: line)
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

    func saveLog(
        _ message: String,
        level: FHXLogType,
        file: String,
        function: String,
        line: Int
    ) {

        // 开关
        guard isEnabled else { return }

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
