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
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getUnitMembers, .addFamilyMember:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .getUnitMembers(unitID, userID):
            return .requestParameters(parameters: ["UNITID": unitID, "USERID": userID].ekey("UNITID"), encoding: URLEncoding.default)
        case let .addFamilyMember(communityID, unitID, userID, name, phone):
            return .requestParameters(parameters: ["TARGETMOBILE": phone, "REALNAME": name, "USERID": userID, "UNITID": unitID, "COMMUNITYID": communityID].ekey("COMMUNITYID"), encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    
}
