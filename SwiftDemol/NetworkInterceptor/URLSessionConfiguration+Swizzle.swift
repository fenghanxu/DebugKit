//
//  URLSessionConfiguration+Swizzle.swift
//  SwiftDemol
//
//  Created by imac on 2026/6/25.
//

import Foundation
import ObjectiveC.runtime

extension URLSessionConfiguration {

    static func fhx_swizzle() {

        swizzleDefault()

        swizzleEphemeral()
    }
}

// MARK: - Swizzle

private extension URLSessionConfiguration {

    static func swizzleDefault() {

        guard
            let original =
            class_getClassMethod(
                self,
                #selector(getter: URLSessionConfiguration.default)
            ),
            let swizzled =
            class_getClassMethod(
                self,
                #selector(getter: URLSessionConfiguration.fhx_default)
            )
        else {
            return
        }

        method_exchangeImplementations(
            original,
            swizzled
        )
    }

    static func swizzleEphemeral() {

        guard
            let original =
            class_getClassMethod(
                self,
                #selector(getter: URLSessionConfiguration.ephemeral)
            ),
            let swizzled =
            class_getClassMethod(
                self,
                #selector(getter: URLSessionConfiguration.fhx_ephemeral)
            )
        else {
            return
        }

        method_exchangeImplementations(
            original,
            swizzled
        )
    }
}

// MARK: - Swizzled Getter

extension URLSessionConfiguration {

    @objc
    class var fhx_default: URLSessionConfiguration {

        let config = fhx_default

        injectProtocol(
            into: config
        )

        return config
    }

    @objc
    class var fhx_ephemeral: URLSessionConfiguration {

        let config = fhx_ephemeral

        injectProtocol(
            into: config
        )

        return config
    }
}

// MARK: - Inject

private extension URLSessionConfiguration {

    static func injectProtocol(
        into configuration: URLSessionConfiguration
    ) {
        print("Inject Protocol")
        guard
            let protocolClass =
            NSClassFromString(
                "\(Bundle.main.infoDictionary?["CFBundleName"] ?? "").FHXURLProtocol"
            ) as? URLProtocol.Type
        else {

            print("FHXURLProtocol Not Found")

            return
        }

        var classes =
        configuration.protocolClasses ?? []

        let exists =
        classes.contains {

            $0 == protocolClass
        }

        if exists {
            return
        }

        classes.insert(
            protocolClass,
            at: 0
        )

        configuration.protocolClasses =
        classes
    }
}
