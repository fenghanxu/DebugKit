//
//  FHXNetworkInterceptor.swift
//  SwiftDemol
//
//  Created by imac on 2026/6/25.
//

import Foundation

final class FHXNetworkInterceptor {

    private static var didStart = false

    static func start() {

        guard !didStart else {
            return
        }

        didStart = true

        FHXURLSessionSwizzle.start()

        FHXCompletionSwizzle.start()

        print("FHXNetworkInterceptor Started")
    }
}
