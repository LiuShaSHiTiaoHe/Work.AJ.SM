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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUnitMembers, .addFamilyMember, .allFace, .deleteFace:
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
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    
}
