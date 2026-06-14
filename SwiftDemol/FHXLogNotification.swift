//
//  FHXLogNotification.swift
//  SwiftDemol
//
//  Created by imac on 2026/6/8.
//

//用于添加新日志，通知出去刷新tableView

import Foundation

extension Notification.Name {

    /// 新增日志
    static let fhxLogDidAppend = Notification.Name("fhxLogDidAppend")

    /// 清空日志
    static let fhxLogDidClear = Notification.Name("fhxLogDidClear")
    
    /// 删除日志
    static let fhxLogDidDelete = Notification.Name("fhxLogDidDelete")

    /// 更新日志
    static let fhxLogDidUpdate = Notification.Name("fhxLogDidUpdate")
}
