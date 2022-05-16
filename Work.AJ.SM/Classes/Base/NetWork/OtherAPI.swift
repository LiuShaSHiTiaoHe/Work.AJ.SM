//
//  OtherAPI.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/5/9.
//

import Moya

enum OtherAPI {
    case AmapLocation(key: String)
}

extension OtherAPI: TargetType {
    var baseURL: URL {
        switch self {
        case .AmapLocation:
            return URL.init(string: "https://restapi.amap.com/")!
        }
    }

    var path: String {
        switch self {
        case .AmapLocation:
            return "v3/ip"
        }
    }

    var method: Moya.Method {
        switch self {
        case .AmapLocation:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .AmapLocation(key):
            return .requestParameters(parameters: ["key": key], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return [:]
    }


}
