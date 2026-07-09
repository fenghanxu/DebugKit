
///  网络监听 增删改查

//import Foundation
//
//final class FHXNetworkStore {
//
//    static let shared = FHXNetworkStore()
//
//    private init() {}
//
//    private var logs: [FHXNetworkLogModel] = []
//
//    private let queue = DispatchQueue(label: "fhx.network.queue")
//
//    func append(_ model: FHXNetworkLogModel) {
//        queue.async {
//            self.logs.append(model)
//            DispatchQueue.main.async {
//                NotificationCenter.default.post(
//                    name: .fhxNetworkDidAppend,
//                    object: model
//                )
//            }
//        }
//    }
//
//    func allLogs() -> [FHXNetworkLogModel] {
//        queue.sync {logs}
//    }
//
//    func clear() {
//        queue.async {
//            self.logs.removeAll()
//            DispatchQueue.main.async {
//                NotificationCenter.default.post(
//                    name: .fhxNetworkDidClear,
//                    object: nil
//                )
//            }
//        }
//    }
//    
//}
