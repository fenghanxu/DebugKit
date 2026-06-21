

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

}

// MARK: - 备用
extension FHXLog {
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

    /// 获取当前日志数据
    func currentLogs() -> [FHXLogModel] {
        store.currentLogs()
    }

    /// 获取历史日志数据
    func historyLogs() -> [FHXLogModel] {
        store.historyLogs()
    }
    
    /// 清空当前日志
    func clearCurrentLogs() {
        store.clearCurrentLogs()
    }
    
    /// 清空历史日志
    func clearHistoryLogs() {
        store.clearHistoryLogs()
    }
    
    /// 删除当前日志单条数据
    func deleteCurrentLog(id: String) {
        store.deleteCurrentLog(id: id)
    }
    
    /// 删除历史日志单条数据
    func deleteHistoryLog(id: String) {
        store.deleteHistoryLog(id: id)
    }

    /// 删除当前日志多条数据
    func deleteCurrentLogs(ids: [String]) {
        store.deleteCurrentLogs(ids: ids)
    }
    
    /// 删除当历史志多条数据
    func deleteHistoryLogs(ids: [String]) {
        store.deleteHistoryLogs(ids: ids)
    }
    
    /// 获取当前日志数量
    func currentLogCount() -> Int {
        store.currentCount()
    }
    
    /// 获取历史日志数量
    func historyLogCount() -> Int {
        store.historyCount()
    }

    /// 更新日志(当前日志 +  历史日志)
    func updateLog(
        _ model: FHXLogModel
    ) {
        store.update(model)
    }


}

// MARK: 导出功能
extension FHXLog {

    /// 整理 TXT
    private func organizeTXT(logs: [FHXLogModel]) -> String {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        return logs.map {

            """
            [\(formatter.string(from: $0.time))]
            [\($0.level)]
            \($0.file).\($0.function):[\($0.line)]
            \($0.message)

            """
        }
        .joined(separator: "\n")
    }

    /// 导出 TXT
    private func exportTXTFile(
        logs: [FHXLogModel],
        prefix: String
    ) throws -> URL {

        let txt = organizeTXT(logs: logs)

        let fileURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent(
                "\(prefix)_\(Int(Date().timeIntervalSince1970)).txt"
            )

        try txt.write(
            to: fileURL,
            atomically: true,
            encoding: .utf8
        )

        return fileURL
    }

    /// 导出 JSON
    private func exportJSONFile(
        logs: [FHXLogModel],
        prefix: String
    ) throws -> URL {

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.dateEncodingStrategy = .iso8601

        let data = try encoder.encode(logs)

        let fileURL = FileManager.default
            .temporaryDirectory
            .appendingPathComponent(
                "\(prefix)_\(Int(Date().timeIntervalSince1970)).json"
            )

        try data.write(to: fileURL)

        return fileURL
    }
}

extension FHXLog {

    // MARK: 当前日志

    func exportCurrentLogsTXTFile() throws -> URL {
        try exportTXTFile(
            logs: currentLogs(),
            prefix: "FHXCurrentLog"
        )
    }

    func exportCurrentLogsJSONFile() throws -> URL {
        try exportJSONFile(
            logs: currentLogs(),
            prefix: "FHXCurrentLog"
        )
    }

    // MARK: 历史日志

    func exportHistoryLogsTXTFile() throws -> URL {
        try exportTXTFile(
            logs: historyLogs(),
            prefix: "FHXHistoryLog"
        )
    }

    func exportHistoryLogsJSONFile() throws -> URL {
        try exportJSONFile(
            logs: historyLogs(),
            prefix: "FHXHistoryLog"
        )
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
