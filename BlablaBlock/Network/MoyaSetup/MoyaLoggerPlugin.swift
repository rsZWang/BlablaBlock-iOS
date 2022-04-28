//
//  MoyaLoggerPlugin.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/11.
//

import Foundation
import Moya

struct MoyaLoggerPlugin: PluginType {
    
    typealias Log = (String, Any)
    private let shouldPrint = true

    func willSend(_ request: RequestType, target: TargetType) {
        if shouldPrint {
            debugRequest(request.request as URLRequest?, target: target)
        }
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            if shouldPrint {
                debugResponse(response, target: target)
            }
        case .failure(let error):
            Timber.e(error)
        }
    }

    func debugRequest(_ request: URLRequest?, target: TargetType) {
        guard let request = request else {
            return
        }
        var logs: [Log] = []
        logs.append(("Target", target))
        logs.append((request.httpMethod ?? "Unknown Method", request.url?.absoluteString ?? "empty url"))
//        logs.append(("Date", Date()))
        logs.append(("Headers", request.allHTTPHeaderFields ?? "[]"))
        if let data = request.httpBody, let prettyString = data.prettyPrintedJSONString {
            logs.append(("Body", prettyString))
        } else {
//            logs.append(("Body", "EMPTY"))
        }
        printLogs(" Request⏩ =", logs: logs)
    }

    func debugResponse(_ response: Response, target: TargetType) {
        var logs: [Log] = []
        logs.append(("Target", target))
//        logs.append((response.request?.httpMethod ?? "Unknown Method", response.request?.url?.absoluteURL ?? "empty url"))
//        logs.append(("Date", Date()))
        logs.append(("Status Code", response.statusCode))
        if let prettyString = response.data.prettyPrintedJSONString {
            logs.append(("Body", prettyString))
        } else {
            logs.append(("Body", "Unparsable"))
        }
        printLogs(" Response⏪ ", logs: logs)
    }

    func printLogs(_ title: String, logs: [Log]) {
        let title = "==============\(title)======================="
        print(title)
        for log in logs {
            print("\(log.0): \(log.1)")
        }
        let separator = title.map { _ in "=" }.joined()
        print("\(separator)=")
    }
}
