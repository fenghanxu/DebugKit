//
//  FHXURLProtocol.swift
//  SwiftDemol
//
//  Created by imac on 2026/6/25.
//

import Foundation

final class FHXURLProtocol: URLProtocol {

    private var session: URLSession?

    private var sessionTask: URLSessionDataTask?

    private var responseData = Data()

    private var startTime: Date?

}

// MARK: - URLProtocol

extension FHXURLProtocol {

    override class func canInit(
        with request: URLRequest
    ) -> Bool {

        guard request.url != nil else {
            return false
        }

        // 防止死循环
        if URLProtocol.property(
            forKey: "FHXHandled",
            in: request
        ) != nil {

            return false
        }

        return true
    }
    
    override class func canInit(
        with task: URLSessionTask
    ) -> Bool {

        return false
    }

    override class func canonicalRequest(
        for request: URLRequest
    ) -> URLRequest {

        request
    }

    override func startLoading() {

        startTime = Date()

        guard let mutableRequest =
                (request as NSURLRequest)
                .mutableCopy()
                as? NSMutableURLRequest
        else {
            return
        }

        URLProtocol.setProperty(
            true,
            forKey: "FHXHandled",
            in: mutableRequest
        )

        let config =
        URLSessionConfiguration.ephemeral

        config.protocolClasses = []

        session =
        URLSession(
            configuration: config,
            delegate: self,
            delegateQueue: nil
        )

        sessionTask =
        session?.dataTask(
            with: mutableRequest as URLRequest
        )

        sessionTask?.resume()
    }

    override func stopLoading() {

        sessionTask?.cancel()

        session?.invalidateAndCancel()

        session = nil
    }
}

// MARK: - URLSessionDataDelegate

extension FHXURLProtocol: URLSessionDataDelegate, URLSessionTaskDelegate {

    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void
    ) {

        client?.urlProtocol(
            self,
            didReceive: response,
            cacheStoragePolicy: .notAllowed
        )

        completionHandler(
            .allow
        )
    }

    func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive data: Data
    ) {

        responseData.append(
            data
        )

        client?.urlProtocol(
            self,
            didLoad: data
        )
    }

    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didCompleteWithError error: Error?
    ) {

        defer {

            if let error = error {

                client?.urlProtocol(
                    self,
                    didFailWithError: error
                )

            } else {

                client?.urlProtocolDidFinishLoading(
                    self
                )
            }
        }

        saveNetworkLog(
            task: task,
            error: error
        )
    }
}

private extension FHXURLProtocol {

    func saveNetworkLog(
        task: URLSessionTask,
        error: Error?
    ) {

        let request =
        task.originalRequest

        let url =
        request?.url?.absoluteString
        ?? ""

        let method =
        request?.httpMethod
        ?? "GET"

        let headers =
        request?.allHTTPHeaderFields
        ?? [:]

//        var parameter = ""

//        if let body =
//            request?.httpBody {
//
//            parameter =
//            String(
//                data: body,
//                encoding: .utf8
//            ) ?? ""
//        }
        
        var parameter = ""

        if let body = request?.httpBody {

            parameter =
            String(
                data: body,
                encoding: .utf8
            ) ?? ""
        }
        else if let url = request?.url,
                let query = url.query {

            parameter = query
        }

        var responseString =
        String(
            data: responseData,
            encoding: .utf8
        ) ?? ""

        if responseString.count > 5000 {

            responseString =
            String(
                responseString.prefix(5000)
            )
        }

        let statusCode =
        (task.response as? HTTPURLResponse)?
            .statusCode ?? 0

        let cost =
        Date()
            .timeIntervalSince(
                startTime ?? Date()
            )

        let model =
        FHXNetworkLogModel(
            url: url,
            method: method,
            headers: headers,
            parameters: parameter,
            response: responseString,
            statusCode: statusCode,
            costTime: cost,
            errorMessage: error?.localizedDescription
        )

        FHXNetworkStore
            .shared
            .append(model)

        printNetworkLog(
            model
        )
    }
}

private extension FHXURLProtocol {

    func printNetworkLog(
        _ model: FHXNetworkLogModel
    ) {

        print("""

        =========================

        \(model.method)

        \(model.url)

        Header
        \(model.headers)

        Parameter
        \(model.parameters)

        Response
        \(model.response)

        StatusCode
        \(model.statusCode)

        CostTime
        \(Int(model.costTime * 1000))ms

        =========================

        """)

    }
}
