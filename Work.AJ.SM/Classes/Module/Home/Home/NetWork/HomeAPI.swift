//
//  HomeAPIManager.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2021/12/28.
//

import Moya

enum HomeAPI {
    case getMyUnit(mobile: String)
    case getAdvertisement(operID: String, communitID: String)
    case getNotice(communitID:String, blockID: String, cellID: String)
}

extension HomeAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: APIs.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .getMyUnit:
            return APIs.userUnit
        case .getAdvertisement:
            return APIs.advertisement
        case .getNotice:
            return APIs.notice
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyUnit, .getNotice, .getAdvertisement:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .getMyUnit(mobile):
            return .requestParameters(parameters: ["MOBILE": mobile].ekey("MOBILE"), encoding: URLEncoding.default)
        case let .getAdvertisement(operID, communitID):
            return .requestParameters(parameters: ["OPERID": operID, "COMMUNITYID": communitID, "COVERS": "A"].ekey("OPERID"), encoding: URLEncoding.default)
        case let .getNotice(communitID, blockID, cellID):
            return .requestParameters(parameters: ["BLOCKID": blockID, "COMMUNITYID": communitID, "CELLID": cellID].ekey("COMMUNITYID"), encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
}

