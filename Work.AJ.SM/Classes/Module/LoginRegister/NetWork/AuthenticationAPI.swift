//
//  AuthenticationAPI.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/11.
//

import Moya

enum AuthenticationAPI {
    case login(mobile: String, passWord: String)
    case regist(mobile: String, code: String, passWord: String)
    case getMessageCode(mobile: String)
}

extension AuthenticationAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: APIs.baseUrl)!
    }
    
    var path: String {
        switch self {
        case .login:
            return APIs.login
        case .regist:
            return APIs.regist
        case .getMessageCode:
            return APIs.msgCode
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .login, .regist, .getMessageCode:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .login(let mobile, let passWord):
            return .requestParameters(parameters: ["MOBILE": mobile, "PASSWORD": passWord].ekey("MOBILE"), encoding: URLEncoding.default)
        case .regist(let mobile, let code, let passWord):
            return .requestParameters(parameters: ["MOBILE": mobile,"CODE": code, "PASSWORD": passWord].ekey("MOBILE"), encoding: URLEncoding.default)
        case .getMessageCode(let mobile):
            return .requestParameters(parameters: ["MOBILE": mobile].ekey("MOBILE"), encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
}

