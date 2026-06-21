

//用于添加新日志，通知出去刷新tableView

import Foundation

extension Notification.Name {

    /// 新增日志
    static let logDidAppendCurrentData = Notification.Name("logDidAppendCurrentData")

    /// 清空当前日志
    static let logDidClearCurrentData = Notification.Name("logDidClearCurrentData")
    
    /// 清空历史日志
    static let logDidClearHistoryData = Notification.Name("logDidClearHistoryData")
    
    /// 删除日志
    static let fhxLogDidDelete = Notification.Name("fhxLogDidDelete")

    /// 更新日志
    static let fhxLogDidUpdate = Notification.Name("fhxLogDidUpdate")
}
