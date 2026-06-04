//
//  FHXLogStore.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/4.
//

import Foundation

final class FHXLogStore {

    private var logs: [FHXLogModel] = []
    private let queue = DispatchQueue(label: "fhx.log.queue")

    func append(_ log: FHXLogModel, maxCount: Int) {

        queue.async {
            self.logs.append(log)

            if self.logs.count > maxCount {
                self.logs.removeFirst()
            }
        }
    }

    func all() -> [FHXLogModel] {
        queue.sync {
            logs
        }
    }

    func clear() {
        queue.sync {
            logs.removeAll()
        }
    }
}
