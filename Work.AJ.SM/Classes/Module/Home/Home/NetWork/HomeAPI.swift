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

    // MARK: - NCOM
    case ncomAllDevice(unitID: String)
    case ncomRecord(communityID: String, startTime: String, endTime: String, page: String, count: String)
    case ncomSendStatus(communityID: String, unitID: String, callSource: String, callTarget: String, callType: Int, callStatus: Int, uniqueCode: String)
}

extension HomeAPI: TargetType {

    var baseURL: URL {
        return URL(string: ApiBaseUrl())!
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
        case .ncomAllDevice:
            return APIs.allDTUInfo
        case .ncomRecord:
            return APIs.allNCallRecord
        case .ncomSendStatus:
            return APIs.sendNCallStatus
        }
    }

    var method: Moya.Method {
        return .post
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
        // MARK: - N方对讲
        case let .ncomAllDevice(unitID):
            return .requestParameters(parameters: ["UNITID": unitID].ekey("UNITID"), encoding: URLEncoding.default)
        case let .ncomRecord(communityID, startTime, endTime, page, count):
            let parameters = ["COMMUNITYID": communityID, "STARTTIME": startTime, "ENDTIME": endTime, "currentPage": page, "showCount": count].ekey("COMMUNITYID")
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        // FIXME: - 待完善
        case .ncomSendStatus:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return [:]
    }

}

