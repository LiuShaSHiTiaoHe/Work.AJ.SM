//
//  OtherAPI.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/5/9.
//

import Moya

enum CommonAPI {
    // MARK: - 高德根据IP获取到位置信息
    case amapLocation(key: String)
    // MARK: - 极光推送请求
    case commonPush(data: CommonPushModel)
}

extension CommonAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .amapLocation:
            return URL.init(string: "https://restapi.amap.com/")!
        case .commonPush:
            return URL(string: APIs.baseUrl)!
        }
    }

    var path: String {
        switch self {
        case .amapLocation:
            return "v3/ip"
        case .commonPush:
            return APIs.commonPush
        }
    }

    var method: Moya.Method {
        switch self {
        case .amapLocation:
            return .get
        case .commonPush:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .amapLocation(key):
            return .requestParameters(parameters: ["key": key], encoding: URLEncoding.default)
        case let .commonPush(data):
            return .requestParameters(parameters: ["alias": data.alias,"aliasType": data.aliasType, "pushFor": data.pushFor, "pushType": data.pushType,
                                                   "type": data.type, "title": data.title, "body": data.body].ekey("alias"),
                    encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return [:]
    }


}
