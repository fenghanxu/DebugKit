//
//  FHXURLSessionSwizzle.swift
//  SwiftDemol
//
//  Created by imac on 2026/6/25.
//

import Foundation
import ObjectiveC.runtime

final class FHXURLSessionSwizzle {

    static func start() {

        let cls: AnyClass =
        URLSessionTask.self

        let original =
        class_getInstanceMethod(
            cls,
            #selector(URLSessionTask.resume)
        )

        let swizzled =
        class_getInstanceMethod(
            cls,
            #selector(URLSessionTask.fhx_resume)
        )

        guard
            let original,
            let swizzled
        else {
            return
        }

        method_exchangeImplementations(
            original,
            swizzled
        )

        print("URLSessionTask Resume Swizzle Success")
    }
}
