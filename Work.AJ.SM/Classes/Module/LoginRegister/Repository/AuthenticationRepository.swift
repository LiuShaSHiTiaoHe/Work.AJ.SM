//
//  LoginRegister.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/2.
//

import UIKit
import Moya

typealias LoginCompletion = ((_ errorMsg: String?) -> Void)

class AuthenticationRepository: NSObject {
    static let shared = AuthenticationRepository()
    
    func login(mobile: String, password: String, completion: @escaping LoginCompletion) {
        AuthenticationAPI.login(mobile: mobile, passWord: password).defaultRequest { JsonData  in
            if let data = JsonData["data"].rawString(), let userInfo = JsonData["map"].rawString(), let units = [UnitModel](JSONString: data), let userModel = UserModel(JSONString: userInfo) {
                ud.loginState = true
                ud.username = mobile
                ud.userMobile = mobile
                ud.password = password
                ud.userRealName = userModel.realName
                ud.userID = userModel.rid
                ud.NIMToken = userModel.loginToken
                GDataManager.shared.setupDataBase()
                RealmTools.addList(units, update: .modified) {}
                RealmTools.add(userModel, update: .modified) {}
                GDataManager.shared.loginNIMSDK()
                GDataManager.shared.pushSetAlias(mobile)
                SVProgressHUD.showSuccess(withStatus: "登录成功")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.resetRootViewController()
                }
                completion(nil)
            }else{
                completion("数据解析错误")
            }
        } failureCallback: { response in
            completion(response.message)
        }
    }
    
    func autoLogin(mobile: String, password: String, completion: @escaping DefaultCompletion) {
        AuthenticationAPI.login(mobile: mobile, passWord: password).defaultRequest { jsonData in
            if let userInfo = jsonData["map"].rawString(), let userModel = UserModel(JSONString: userInfo) {
                ud.loginState = true
                ud.username = mobile
                ud.userMobile = mobile
                ud.password = password
                ud.userRealName = userModel.realName
                ud.userID = userModel.rid
                ud.NIMToken = userModel.loginToken
                RealmTools.add(userModel, update: .modified) {}
                completion("")
            }
        } failureCallback: { response in
            completion(response.message)
        }

    }
    
    func register(mobile: String, passWord: String, code: String, completion: @escaping LoginCompletion) {
        AuthenticationAPI.regist(mobile: mobile, code: code, passWord: passWord).defaultRequest { jsonData in
            completion(nil)
        } failureCallback: { response in
            completion(response.message)
        }
    }
    
    
    func sendMessageCode(_ mobile: String, completion: @escaping LoginCompletion) {
        AuthenticationAPI.getMessageCode(mobile: mobile).defaultRequest { jsonData in
            completion(nil)
        } failureCallback: { response in
            completion(response.message)
        }
    }
    
    func checkMessageCode(mobile: String, code: String, completion: @escaping LoginCompletion) {
        AuthenticationAPI.checkMessageCode(mobile: mobile, code: code).defaultRequest { jsonData in
            completion(nil)
        } failureCallback: { response in
            completion(response.message)
        }
    }
    
    func resetPassword(mobile: String, password: String, completion: @escaping LoginCompletion) {
        AuthenticationAPI.resetPassword(mobile: mobile, password: password).defaultRequest { jsonData in
            completion(nil)
        } failureCallback: { response in
            completion(response.message)
        }
    }
    
    
}
