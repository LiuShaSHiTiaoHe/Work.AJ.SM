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
    
    func login(mobile: String, passWord: String, completion: @escaping LoginCompletion) {
        AuthenticationAPI.login(mobile: mobile, passWord: passWord).defaultRequest { JsonData  in
            if let data = JsonData["data"].rawString(), let userInfo = JsonData["map"].rawString(), let units = [UnitModel](JSONString: data), let userModel = UserModel(JSONString: userInfo) {
                Defaults.username = mobile
                ud.userMobile = mobile
                Defaults.userRealName = userModel.realName
                Defaults.userID = userModel.rid
                GDataManager.shared.setupDataBase()
                RealmTools.addList(units) {}
                RealmTools.add(userModel) {}
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
