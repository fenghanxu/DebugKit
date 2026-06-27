//
//  FHXDebugKit.swift
//  SwiftDemol
//
//  Created by imac on 2026/6/25.
//

import Foundation

public final class FHXDebugKit {

    public static func start() {

        FHXNetworkInterceptor.start()

        print("FHXDebugKit Started")
    }
}
