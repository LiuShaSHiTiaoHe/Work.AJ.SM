//
//  MineAPIs.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/15.
//

import Moya

enum MineAPI {
    case getUnitMembers(unitID: String, userID: String)
    case addFamilyMember(communityID: String, unitID: String, userID: String, name: String, phone: String)
    case allFace(communityID: String, blockID: String, cellID: String, unitID: String)
    case deleteFace(communityID: String, blockID: String, cellID: String, unitID: String, imagePath: String)
    case versionCheck(type: String)
    case deleteAccount(userID: String)
    case ownerOpenDoorPassword(communityID: String, unitID: String, blockID: String, userID: String, phone: String, openDoorPassword: String)
    case allCity(encryptString: String)
    case communitiesInCity(city: String)
    case blockInCommunity(communityID: String)
    case cellInBlock(blockID: String)
    case unitInCell(blockID: String, cellID: String)
    case houseAuthentication(data: HouseCertificationModel)
}

extension MineAPI: TargetType {
    var baseURL: URL {
        return URL(string: APIs.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .getUnitMembers:
            return APIs.unitMembers
        case .addFamilyMember:
            return APIs.addFamilyMember
        case .allFace:
            return APIs.faceFile
        case .deleteFace:
            return APIs.deleteFaceFile
        case .versionCheck:
            return APIs.versionCheck
        case .deleteAccount:
            return APIs.deleteAccount
        case .ownerOpenDoorPassword:
            return APIs.ownerOpenDoorPassword
        case .allCity:
            return APIs.allCity
        case .communitiesInCity:
            return APIs.userCommunity
        case .blockInCommunity:
            return APIs.userBlock
        case .cellInBlock:
            return APIs.userCell
        case .unitInCell:
            return APIs.allUnit
        case .houseAuthentication:
            return APIs.houseAuthentication
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUnitMembers, .addFamilyMember, .allFace, .deleteFace, .versionCheck, .deleteAccount, .ownerOpenDoorPassword, .allCity, .communitiesInCity, .blockInCommunity, .cellInBlock, .unitInCell, .houseAuthentication:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .getUnitMembers(unitID, userID):
            return .requestParameters(parameters: ["UNITID": unitID, "USERID": userID].ekey("UNITID"), encoding: URLEncoding.default)
        case let .addFamilyMember(communityID, unitID, userID, name, phone):
            return .requestParameters(parameters: ["TARGETMOBILE": phone, "REALNAME": name, "USERID": userID, "UNITID": unitID, "COMMUNITYID": communityID].ekey("COMMUNITYID"), encoding: URLEncoding.default)
        case let .allFace(communityID, blockID, cellID, unitID):
            return .requestParameters(parameters: ["COMMUNITYID": communityID, "BLOCKID": blockID, "CELLID": cellID, "UNITID": unitID].ekey("COMMUNITYID"), encoding: URLEncoding.default)
        case let .deleteFace(communityID, blockID, cellID, unitID, imagePath):
            return .requestParameters(parameters: ["COMMUNITYID": communityID, "BLOCKID": blockID, "CELLID": cellID, "UNITID": unitID, "IMAGE": imagePath].ekey("COMMUNITYID"), encoding: URLEncoding.default)
        case let .versionCheck(type):
            return .requestParameters(parameters: ["TYPE": type].ekey("TYPE"), encoding: URLEncoding.default)
        case let .deleteAccount(userID):
            return .requestParameters(parameters: ["USERID": userID].ekey("USERID"), encoding: URLEncoding.default)
        case let .ownerOpenDoorPassword(communityID, unitID, blockID, userID, phone, openDoorPassword):
            return .requestParameters(parameters: ["COMMUNITYID": communityID, "UNITID": unitID, "BLOCKID": blockID, "USERID": userID, "PHONE": phone, "PASSWORD": openDoorPassword].ekey("COMMUNITYID"), encoding: URLEncoding.default)
        case .allCity(_):
            return .requestParameters(parameters: ["ignore": ""].ekey("ignore"), encoding: URLEncoding.default)
        case let .communitiesInCity(city):
            return .requestParameters(parameters: ["CITY": city].ekey("CITY"), encoding: URLEncoding.default)
        case let .blockInCommunity(communityID):
            return .requestParameters(parameters: ["COMMUNITYID": communityID].ekey("COMMUNITYID"), encoding: URLEncoding.default)
        case let .cellInBlock(blockID):
            return .requestParameters(parameters: ["BLOCKID": blockID].ekey("BLOCKID"), encoding: URLEncoding.default)
        case let .unitInCell(blockID, cellID):
            return .requestParameters(parameters: ["BLOCKID": blockID, "CELLID": cellID].ekey("BLOCKID"), encoding: URLEncoding.default)
        case let .houseAuthentication(data):
            return .requestParameters(parameters: ["MOBILE": data.phone, "REALNAME": data.name, "IDCARD": data.userIdentityCardNumber, "USERTYPE": data.userType, "COMMUNITYID": data.communityID, "BLOCKID": data.blockID, "UNITID": data.unitID, "USERID": data.userID].ekey("COMMUNITYID"), encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    
}
