//
//  HomeAPIManager.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2021/12/28.
//

import Moya

enum HomeAPI {
    case getMyUnit(mobile: String)
    case getAdvertisement(operID: String, communityID: String)
    case getNotice(communityID:String, blockID: String, cellID: String)
    case getElevators(communityID:String, unitID: String, cellID: String, groupID: String)
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
        case .getElevators:
            return APIs.cellGroupElevators
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyUnit, .getNotice, .getAdvertisement, .getElevators:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .getMyUnit(mobile):
            return .requestParameters(parameters: ["MOBILE": mobile].ekey("MOBILE"), encoding: URLEncoding.default)
        case let .getAdvertisement(operID, communityID):
            return .requestParameters(parameters: ["OPERID": operID, "COMMUNITYID": communityID, "COVERS": "A"].ekey("OPERID"), encoding: URLEncoding.default)
        case let .getNotice(communityID, blockID, cellID):
            return .requestParameters(parameters: ["BLOCKID": blockID, "COMMUNITYID": communityID, "CELLID": cellID].ekey("COMMUNITYID"), encoding: URLEncoding.default)
        case let .getElevators(communityID, unitID, cellID, groupID):
            return .requestParameters(parameters: ["COMMUNITYID": communityID, "CELLID": cellID, "UNITID": unitID, "GROUPID": groupID].ekey("CELLID"), encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
}

