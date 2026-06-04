//
//  System.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/4.
//

import UIKit

enum SystemModelLevel {
    case debug
    case info
    case warning
    case error
}

struct SystemModel {
    let message: String
    let level: SystemModelLevel
    let time: Date
    let file: String
    let function: String
    let line: Int
}

class System {

    static let shared = System()

    private init() {}

    // MARK: - data
    private var list: [SystemModel] = []

    // MARK: - config
    var isEnabled = true
    var maxCount = 1000

    // MARK: - filter state（关键）
    private var currentLevel: SystemModelLevel?

    // MARK: - 写入日志
    func log(
        _ message: String,
        level: SystemModelLevel,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {

        guard isEnabled else { return }

        let fileName = URL(fileURLWithPath: file)
            .deletingPathExtension()
            .lastPathComponent

        let model = SystemModel(
            message: message,
            level: level,
            time: Date(),
            file: fileName,
            function: function,
            line: line
        )

        list.append(model)

        // 限制数量
        if list.count > maxCount {
            list.removeFirst()
        }

        print("[\(level)] \(message)")
    }
}

// filter（实现链式）
extension System {

    @discardableResult
    func filter(_ level: SystemModelLevel) -> Self {
        self.currentLevel = level
        return self
    }
}

// search
extension System {

    func search(_ keyword: String) -> [SystemModel] {
        list.filter {
            $0.message.contains(keyword)
        }
    }
}


// export（支持链式过滤）
extension System {

    func export() -> [SystemModel] {

        guard let level = currentLevel else {
            return list
        }

        return list.filter { $0.level == level }
    }
}

// clear
extension System {

    func clear() {
        list.removeAll()
    }
}

