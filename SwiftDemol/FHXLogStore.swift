//
//  FHXLogStore.swift
//  SwiftDemol
//
//  Created by fenghanxu on 2026/6/4.
//

import Foundation

class FHXLogStore {
    
    private var logs: [FHXLogModel] = []
    private let queue = DispatchQueue(label: "log.queue")
    
    func append(_ log: FHXLogModel) {
        queue.async {
            self.logs.append(log)
            
            // 限制数量，避免内存爆
            if self.logs.count > 500 {
                self.logs.removeFirst()
            }
        }
    }
    
    func all() -> [FHXLogModel] {
        queue.sync {
            logs
        }
    }
}
