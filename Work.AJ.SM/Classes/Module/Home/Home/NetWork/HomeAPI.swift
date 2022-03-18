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
    case getLocks(communityID: String, blockID: String, cellID: String, unitID: String, userID: String, physicfloor: String)
    case getUserOfflineQRCode(unitID: String)
    case getInvitationQRCode(unitID: String, arriveTime: String, validTime: String)
    case generateVisitorPassword(communityID: String, blockID: String, unitID: String, userID: String, phone: String, time: String, type: String)
    case getFloorsBySN(SNCode: String, phone: String, userID: String)
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
        case .getLocks:
            return APIs.locks
        case .getUserOfflineQRCode, .getInvitationQRCode:
            return APIs.userQRCode
        case .generateVisitorPassword:
            return APIs.generateVisitorPassword
        case .getFloorsBySN:
            return APIs.floorsBySN
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyUnit, .getNotice, .getAdvertisement, .getElevators, .getLocks, .getUserOfflineQRCode, .getInvitationQRCode, .generateVisitorPassword, .getFloorsBySN:
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
        case let .getLocks(communityID, blockID, cellID, unitID, userID, _):
//            return .requestParameters(parameters: ["COMMUNITYID": communityID, "BLOCKID": blockID, "CELLID": cellID, "UNITID": unitID, "USERID": userID, "PHYSICALFLOOR": physicfloor].ekey("COMMUNITYID"), encoding: URLEncoding.default)
            return .requestParameters(parameters: ["COMMUNITYID": communityID, "BLOCKID": blockID, "CELLID": cellID, "UNITID": unitID, "USERID": userID].ekey("COMMUNITYID"), encoding: URLEncoding.default)
        case let .getUserOfflineQRCode(unitID):
            return .requestParameters(parameters: ["UNITID": unitID, "isVisitor": "0"].ekey("UNITID"), encoding: URLEncoding.default)
        case let .getInvitationQRCode(unitID, arriveTime, validTime):
            return .requestParameters(parameters: ["UNITID": unitID, "isVisitor": "1", "startTime": arriveTime, "endTime": validTime].ekey("UNITID"), encoding: URLEncoding.default)
        case let .generateVisitorPassword(communityID, blockID, unitID, userID, phone, time, type):
            return .requestParameters(parameters: ["COMMUNITYID": communityID, "BLOCKID": blockID, "UNITID": unitID, "USERID": userID, "PHONE": phone, "HOUR": time, "PASSTYPE": type].ekey("COMMUNITYID"), encoding: URLEncoding.default)
        case let .getFloorsBySN(SNCode, phone, userID):
            return .requestParameters(parameters: ["LIFTSN": SNCode, "MOBILE": phone, "USERID": userID].ekey("LIFTSN"), encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
}

