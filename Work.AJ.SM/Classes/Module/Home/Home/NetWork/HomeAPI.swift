//
//  HomeAPIManager.swift
//  SmartCommunity
//
//  Created by Anjie on 2021/12/28.
//

import Moya

enum HomeAPI {
    case getMyUnit(mobile: String)
    case getAdvertisement(operID: String, communityID: String)
    case getNotice(communityID: String, blockID: String, cellID: String)
    case getElevators(communityID: String, unitID: String, cellID: String, groupID: String)
    case getLocks(communityID: String, blockID: String, cellID: String, unitID: String, userID: String, physicfloor: String)
    case getUserOfflineQRCode(unitID: String, communityID: String, blockID: String, userID: String)
    case getInvitationQRCode(unitID: String, arriveTime: String, validTime: String, communityID: String, blockID: String, userID: String)
    case generateVisitorPassword(communityID: String, blockID: String, unitID: String, userID: String, phone: String, sDate: String, eDate: String, type: String)
    case getFloorsBySN(SNCode: String, phone: String, userID: String)
    case openDoor(lockMac: String, userID: String, communityID: String, blockID: String, unitID: String, cellID: String, physicalFloor: String)
    case callElevatorViaMobile(cellID: String, direction: String, physicalFloor: String, unitNo: String)
    case getElevatorConfiguration(communityID: String)
    case getAgoraRtmToken(account: String)
    case getAgoraRtcToken(channel: String)
    case getSpecificPageNotice(pageID: String, communityID: String, userID: String)
    case getModuleStatusByVersion(unitID: String, communityID: String, userID: String)
}

extension HomeAPI: TargetType {

    var baseURL: URL {
        URL(string: ApiBaseUrl())!
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
        case .openDoor:
            return APIs.openDoor
        case .callElevatorViaMobile:
            return APIs.indoorCallElevator
        case .getElevatorConfiguration:
            return APIs.elevatorConfiguration
        case .getSpecificPageNotice:
            return APIs.specificPageNotice
        case .getModuleStatusByVersion:
            return APIs.moduleStatusWithVersion
        case .getAgoraRtmToken:
            return APIs.getAgoraRtmToken
        case .getAgoraRtcToken:
            return APIs.getAgoraRtcToken
        }
    }

    var method: Moya.Method {
        switch self {
        case .getAgoraRtmToken, .getAgoraRtcToken:
            return .get
        default:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .getMyUnit(mobile):
            return .requestParameters(parameters: ["MOBILE": mobile, "apiVersion": "1"].ekey("MOBILE"), encoding: URLEncoding.default)
        case let .getAdvertisement(operID, communityID):
            return .requestParameters(parameters: ["OPERID": operID, "COMMUNITYID": communityID, "COVERS": "A"].ekey("OPERID"), encoding: URLEncoding.default)
        case let .getNotice(communityID, blockID, cellID):
            return .requestParameters(parameters: ["BLOCKID": blockID, "COMMUNITYID": communityID, "CELLID": cellID].ekey("COMMUNITYID"), encoding: URLEncoding.default)
        case let .getElevators(communityID, unitID, cellID, groupID):
            return .requestParameters(parameters: ["COMMUNITYID": communityID, "CELLID": cellID, "UNITID": unitID, "GROUPID": groupID].ekey("CELLID"), encoding: URLEncoding.default)
        case let .getLocks(communityID, blockID, cellID, unitID, userID, _):
            return .requestParameters(parameters: ["COMMUNITYID": communityID, "BLOCKID": blockID, "CELLID": cellID, "UNITID": unitID, "USERID": userID].ekey("COMMUNITYID"), encoding: URLEncoding.default)
        case let .getUserOfflineQRCode(unitID, communityID, blockID, userID):
            return .requestParameters(parameters: ["UNITID": unitID, "COMMUNITYID": communityID, "BLOCKID": blockID, "USERID": userID, "isVisitor": "0"].ekey("UNITID"), encoding: URLEncoding.default)
        case let .getInvitationQRCode(unitID, arriveTime, validTime, communityID, blockID, userID):
            return .requestParameters(parameters: ["UNITID": unitID, "COMMUNITYID": communityID, "BLOCKID": blockID, "USERID": userID, "isVisitor": "1", "startTime": arriveTime, "endTime": validTime].ekey("UNITID"), encoding: URLEncoding.default)
        case let .generateVisitorPassword(communityID, blockID, unitID, userID, phone, sDate, eDate, type):
            return .requestParameters(parameters: ["COMMUNITYID": communityID, "BLOCKID": blockID, "UNITID": unitID, "USERID": userID, "PHONE": phone, "apiVersion": "1", "STARTDATE": sDate, "ENDDATE": eDate, "PASSTYPE": type, "needPwd": "1"].ekey("COMMUNITYID"), encoding: URLEncoding.default)
        case let .getFloorsBySN(SNCode, phone, userID):
            return .requestParameters(parameters: ["LIFTSN": SNCode, "MOBILE": phone, "USERID": userID].ekey("LIFTSN"), encoding: URLEncoding.default)
        case let .openDoor(lockMac, userID, communityID, blockID, unitID, cellID, physicalFloor):
            return .requestParameters(parameters: ["LOCKMAC": lockMac, "USERID": userID, "COMMUNITYID": communityID, "BLOCKID": blockID, "UNITID": unitID, "CELLID": cellID, "PHYSICALFLOOR": physicalFloor].ekey("LOCKMAC"), encoding: URLEncoding.default)
        case let .callElevatorViaMobile(cellID, direction, physicalFloor, unitNo):
            return .requestParameters(parameters: ["CELLID": cellID, "DIRECTION": direction, "PHYSICALFLOOR": physicalFloor, "LANDINGTYPE": "E", "UNITNO": unitNo].ekey("CELLID"), encoding: URLEncoding.default)
        case let .getElevatorConfiguration(communityID):
            return .requestParameters(parameters: ["COMMUNITYID": communityID].ekey("COMMUNITYID"), encoding: URLEncoding.default)
        case let .getSpecificPageNotice(pageID, communityID, userID):
            return .requestParameters(parameters: ["PAGEID": pageID, "USERID": userID, "COMMUNITYID": communityID].ekey("PAGEID"), encoding: URLEncoding.default)
        case .getModuleStatusByVersion(_, _, userID):
            return .requestParameters(parameters: ["USERID": userID].ekey("USERID"), encoding: URLEncoding.default)
        case let .getAgoraRtmToken(account):
            return .requestParameters(parameters: ["userAccount": account, "expirationTimeInSeconds": 36000].ekey("userAccount"), encoding: URLEncoding.default)
        case let .getAgoraRtcToken(channel):
            // MARK: - 主要是根据channel获取token
            return .requestParameters(parameters: ["userAccount": "0", "channelName": channel, "expirationTimeInSeconds": 36000].ekey("userAccount"), encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        [:]
    }

}

