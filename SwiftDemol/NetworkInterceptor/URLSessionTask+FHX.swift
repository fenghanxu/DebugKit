//
//  URLSessionTask+FHX.swift
//  SwiftDemol
//
//  Created by imac on 2026/6/25.
//

import Foundation
import ObjectiveC.runtime

private var FHXStartTimeKey: UInt8 = 0

extension URLSessionTask {

    @objc
    func fhx_resume() {

        objc_setAssociatedObject(
            self,
            &FHXStartTimeKey,
            Date(),
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        )

        print("""
        
        =========================
        REQUEST
        \(originalRequest?.httpMethod ?? "")
        \(originalRequest?.url?.absoluteString ?? "")
        =========================
        
        """)

        fhx_resume()
    }

    var fhx_startTime: Date? {

        objc_getAssociatedObject(
            self,
            &FHXStartTimeKey
        ) as? Date
    }
}
