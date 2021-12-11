//
//  MoyaLoggerPlugin.swift
//  BlablaBlock
//
//  Created by YINGHAO WANG on 2021/12/11.
//

import Moya

struct MoyaLoggerPlugin: PluginType {
    
    typealias Log = (String, Any)

    func willSend(_ request: RequestType, target: TargetType) {
        debugRequest(request.request as URLRequest?, target: target)
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            debugResponse(response, target: target)
        case .failure(let error):
            Timber.e(error)
        }
    }

    func debugRequest(_ request: URLRequest?, target: TargetType) {
        guard let request = request else {
            return
        }

        var logs: [Log] = []
        logs.append((request.httpMethod ?? "", request.url?.absoluteString ?? ""))
//        logs.append(("Date", Date()))
        logs.append(("Headers", request.allHTTPHeaderFields ?? ""))
        if let data = request.httpBody {
            logs.append(("Body", String(decoding: data, as: UTF8.self)))
        } else {
//            logs.append(("Data", "None"))
        }
        logs.append(("Target", target))

        printLogs("⬆️Request ", logs: logs)
    }

    func debugResponse(_ response: Response, target: TargetType) {
        var logs: [Log] = []
//        logs.append(("URL: ", response.request?.url?.absoluteURL ?? ""))
//        logs.append(("Method", response.request?.httpMethod ?? ""))
//        logs.append(("Date", Date()))
        logs.append(("Status Code", response.statusCode))
        logs.append(("Body", String(decoding: response.data, as: UTF8.self)))
        logs.append(("Target", target))

        printLogs("⬇️Response", logs: logs)
    }

    func printLogs(_ title: String, logs: [Log]) {
        let title = "============== \(title) ======================="
        let separator = title.map { _ in "=" }.joined()
        print(title)
        for log in logs {
            print("\(log.0): \(log.1)")
        }
        print(separator)
    }
}
