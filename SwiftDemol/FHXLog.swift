//
//  FHXLog.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/4.
//

import Foundation

// 日志等级：
enum FHXLogType: Int, Codable {
    case debug = 0 // 日志
    case network   // 网络
    case error     // 错误
    case crash     // 崩溃
}

struct FHXLogModel: Codable {

    /// 唯一标识
    let id: String

    /// 日志内容
    let message: String

    /// 日志等级
    let level: FHXLogType

    /// 时间
    let time: Date

    /// 文件
    let file: String

    /// 方法
    let function: String

    /// 行数
    let line: Int

    init(
        id: String = UUID().uuidString,
        message: String,
        level: FHXLogType,
        time: Date,
        file: String,
        function: String,
        line: Int
    ) {
        self.id = id
        self.message = message
        self.level = level
        self.time = time
        self.file = file
        self.function = function
        self.line = line
    }
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
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: .fhxLogDidClear,
                object: nil
            )
        }
    }
    
    func deleteLog(
        id: String
    ) {
        store.delete(id: id)
    }

    func deleteLogs(
        ids: [String]
    ) {
        store.delete(ids: ids)
    }

    func updateLog(
        _ model: FHXLogModel
    ) {
        store.update(model)
    }

    func logCount() -> Int {
        store.count()
    }
}

// MARK: 导出功能
extension FHXLog {
    
    func exportTXT() -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return allLogs()
            .map {

                """
                [\(formatter.string(from: $0.time))]
                [\($0.level)]
                \($0.file).\($0.function):[\($0.line)]
                \($0.message)

                """
            }
            .joined(separator: "\n")
    }
    
    func saveTXTFile() throws -> URL {

        let txt = exportTXT()

        let fileURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent(
                "FHXLog_\(Int(Date().timeIntervalSince1970)).txt"
            )

        try txt.write(
            to: fileURL,
            atomically: true,
            encoding: .utf8
        )

        return fileURL
    }
    
    func saveJSONFile() throws -> URL {

        let logs = allLogs()

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601

        let data = try encoder.encode(logs)

        let fileURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent(
                "FHXLog_\(Int(Date().timeIntervalSince1970)).json"
            )

        try data.write(to: fileURL)

        return fileURL
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
