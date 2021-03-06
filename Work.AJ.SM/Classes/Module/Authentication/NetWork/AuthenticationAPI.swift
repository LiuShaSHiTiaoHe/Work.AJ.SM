//
//  AuthenticationAPI.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/11.
//

import Moya
import JKSwiftExtension

enum AuthenticationAPI {
    case login(mobile: String, passWord: String)
    case register(mobile: String, code: String, passWord: String)
    case getMessageCode(mobile: String)
    case checkMessageCode(mobile: String, code: String)
    case resetPassword(mobile: String, password: String)
}

extension AuthenticationAPI: TargetType {

    var baseURL: URL {
        URL(string: ApiBaseUrl())!
    }

    var path: String {
        switch self {
        case .login:
            return APIs.login
        case .register:
            return APIs.register
        case .getMessageCode:
            return APIs.msgCode
        case .checkMessageCode:
            return APIs.checkMsgCode
        case .resetPassword:
            return APIs.resetPassword
        }
    }

    var method: Moya.Method {
        switch self {
        case .login, .register, .getMessageCode, .checkMessageCode, .resetPassword:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .login(mobile, passWord):
            return .requestParameters(parameters: ["MOBILE": mobile, "PASSWORD": passWord, "apiVersion": "1",].ekey("MOBILE"), encoding: URLEncoding.default)
        case let .register(mobile, code, passWord):
            return .requestParameters(parameters: ["MOBILE": mobile, "CODE": code, "PASSWORD": passWord,
                                                   "USERNAME": mobile.jk.sub(from: mobile.count - 4),
                                                   "REALNAME": mobile.jk.sub(from: mobile.count - 4)].ekey("USERNAME"), encoding: URLEncoding.default)
        case let .getMessageCode(mobile):
            return .requestParameters(parameters: ["MOBILE": mobile].ekey("MOBILE"), encoding: URLEncoding.default)
        case let .checkMessageCode(mobile, code):
            return .requestParameters(parameters: ["MOBILE": mobile, "CODE": code].ekey("MOBILE"), encoding: URLEncoding.default)
        case let .resetPassword(mobile, password):
            return .requestParameters(parameters: ["MOBILE": mobile, "NEWPASSWORD": password].ekey("MOBILE"), encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return [:]
    }

}

