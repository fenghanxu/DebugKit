//
//  FHXLogStore.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/4.
//

import Foundation

final class FHXLogStore {
    
    // MARK: - Data

    private var logs: [FHXLogModel] = []
    
    private let queue = DispatchQueue(label: "fhx.log.queue")
    
    // MARK: - File路径

    private lazy var fileURL: URL = {
        let document = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first!

        return document.appendingPathComponent(
            "fhx_logs.json"
        )
    }()

    // MARK: - Init

    init() {
        load()
    }

}

// MARK: - 读取

private extension FHXLogStore {
    func load() {
        queue.sync {
            guard FileManager.default.fileExists(
                atPath: fileURL.path
            ) else {
                return
            }

            do {
                let data =
                try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                logs = try decoder.decode([FHXLogModel].self, from: data)
            } catch {
                print("FHXLog load error:", error)
            }
        }
    }
}

// MARK: 新增日志

extension FHXLogStore {

    func append(
        _ log: FHXLogModel,
        maxCount: Int
    ) {
        queue.async {
            self.logs.append(log)
            if self.logs.count > maxCount {
                let overflow =
                self.logs.count - maxCount
                self.logs.removeFirst(overflow)
            }
            self.save()
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .fhxLogDidAppend,
                    object: log
                )
            }
        }
    }
}

// MARK: 查询

extension FHXLogStore {

    func all() -> [FHXLogModel] {
        queue.sync {
            logs
        }
    }

    func count() -> Int {
        queue.sync {
            logs.count
        }
    }

    func first() -> FHXLogModel? {
        queue.sync {
            logs.first
        }
    }

    func last() -> FHXLogModel? {
        queue.sync {
            logs.last
        }
    }
}

// MARK: 删除单条

extension FHXLogStore {

    func delete(
        id: String
    ) {
        queue.async {
            self.logs.removeAll {
                $0.id == id
            }
            self.save()
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .fhxLogDidDelete,
                    object: id
                )
            }
        }
    }
}

// MARK: 删除多条

extension FHXLogStore {

    func delete(
        ids: [String]
    ) {
        queue.async {
            self.logs.removeAll {
                ids.contains($0.id)
            }
            self.save()
        }
    }
}

// MARK: 更新（虽然日志通常不会更新，备用）

extension FHXLogStore {

    func update(
        _ model: FHXLogModel
    ) {
        queue.async {
            guard let index =
                    self.logs.firstIndex(
                        where: {
                            $0.id == model.id
                        }
                    )
            else {
                return
            }
            self.logs[index] = model
            self.save()
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .fhxLogDidUpdate,
                    object: model
                )
            }
        }
    }
}

// MARK: 清空

extension FHXLogStore {

    func clear() {
        queue.async {
            self.logs.removeAll()
            self.save()
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .fhxLogDidClear,
                    object: nil
                )
            }
        }
    }
    
}


// MARK: 保存

private extension FHXLogStore {

    func save() {

        do {

            let encoder = JSONEncoder()

            encoder.dateEncodingStrategy = .iso8601

            let data =
            try encoder.encode(logs)

            try data.write(
                to: fileURL,
                options: .atomic
            )

        } catch {

            print(
                "FHXLog save error:",
                error
            )
        }
    }
}
