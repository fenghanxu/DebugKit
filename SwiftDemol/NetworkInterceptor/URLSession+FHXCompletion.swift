//
//  URLSession+FHXCompletion.swift
//  SwiftDemol
//
//  Created by imac on 2026/6/26.
//

import Foundation
import ObjectiveC.runtime

final class FHXCompletionSwizzle {

    static func start() {

        let cls: AnyClass = URLSession.self

        let selector1 =
        NSSelectorFromString(
            "dataTaskWithRequest:completionHandler:"
        )

        let selector2 =
        #selector(
            URLSession.fhx_dataTask(
                with:completionHandler:
            )
        )

        guard
            let original =
            class_getInstanceMethod(
                cls,
                selector1
            ),
            let swizzled =
            class_getInstanceMethod(
                cls,
                selector2
            )
        else {

            print("Completion Swizzle Fail")

            return
        }

        method_exchangeImplementations(
            original,
            swizzled
        )

        print("Completion Swizzle Success")
    }
}

extension URLSession {

    @objc
    func fhx_dataTask(
        with request: URLRequest,
        completionHandler: @escaping (
            Data?,
            URLResponse?,
            Error?
        ) -> Void
    ) -> URLSessionDataTask {

        let startTime = Date()

        let wrappedCompletion:
        (
            Data?,
            URLResponse?,
            Error?
        ) -> Void = {

            data,
            response,
            error in

            let cost =
            Date().timeIntervalSince(
                startTime
            )

            let statusCode =
            (response as? HTTPURLResponse)?
                .statusCode ?? 0

            let responseString =
            String(
                data: data ?? Data(),
                encoding: .utf8
            ) ?? ""

            let parameter =
            request.httpBody.flatMap {

                String(
                    data: $0,
                    encoding: .utf8
                )
            } ?? ""

            let model =
            FHXNetworkLogModel(
                url:
                request.url?
                    .absoluteString
                ?? "",

                method:
                request.httpMethod
                ?? "GET",

                headers:
                request.allHTTPHeaderFields
                ?? [:],

                parameters:
                parameter,

                response:
                responseString,

                statusCode:
                statusCode,

                costTime:
                cost,

                errorMessage:
                error?.localizedDescription
            )

            FHXNetworkStore.shared.append(
                model
            )

            print("""

            =========================

            \(model.method)

            \(model.url)

            Header
            \(model.headers)

            Parameter
            \(model.parameters)

            Response
            \(responseString.prefix(500))

            StatusCode
            \(statusCode)

            CostTime
            \(Int(cost * 1000))ms

            =========================

            """)

            completionHandler(
                data,
                response,
                error
            )
        }

        return fhx_dataTask(
            with: request,
            completionHandler: wrappedCompletion
        )
    }
}
