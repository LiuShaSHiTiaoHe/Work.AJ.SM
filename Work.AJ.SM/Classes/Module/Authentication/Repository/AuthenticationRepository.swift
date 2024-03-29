//
//  LoginRegister.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/3/2.
//

import UIKit
import Moya

typealias LoginCompletion = (_ errorMsg: String?) -> Void

class AuthenticationRepository: NSObject {
    static let shared = AuthenticationRepository()
    func login(mobile: String, password: String, completion: @escaping LoginCompletion) {
        AuthenticationAPI.login(mobile: mobile, passWord: password).defaultRequest { JsonData in
            if let userData = JsonData["map"].rawString(), let userModel = UserModel(JSONString: userData) {
                ud.loginState = true
                ud.userLastLoginDate = Date()
                ud.userName = mobile
                ud.userMobile = mobile
                ud.password = password
                ud.userRealName = userModel.realName
                ud.userID = userModel.rid
                GDataManager.shared.setupDataBase()
                GDataManager.shared.loginAgoraRtm()
                GDataManager.shared.pushSetAlias(mobile)
                RealmTools.add(userModel, update: .modified) {}
                if let data = JsonData["data"].rawString(), let units = [UnitModel](JSONString: data) {
                    GDataManager.shared.clearUserUnit()
                    RealmTools.addList(units, update: .all) {}
                    if let unit = units.first(where: {$0.state == UnitStatus.Normal.rawValue}),
                       let unitID = unit.unitid, let communityID = unit.communityid {
                        ud.currentUnitID = unitID
                        ud.currentCommunityID = communityID
                    }
                }
                SVProgressHUD.showSuccess(withStatus: "登录成功")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.resetRootViewController()
                }
                completion(nil)
            } else {
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
                ud.userLastLoginDate = Date()
                ud.userName = mobile
                ud.userMobile = mobile
                ud.password = password
                ud.userRealName = userModel.realName
                ud.userID = userModel.rid
                GDataManager.shared.loginAgoraRtm()
                RealmTools.add(userModel, update: .modified) {}
                if let data = jsonData["data"].rawString(), let units = [UnitModel](JSONString: data) {
                    GDataManager.shared.clearUserUnit()
                    RealmTools.addList(units, update: .all) {}
                    if let unit = units.first(where: {$0.state == UnitStatus.Normal.rawValue}),
                       let unitID = unit.unitid, let communityID = unit.communityid {
                        ud.currentUnitID = unitID
                        ud.currentCommunityID = communityID
                    }
                 }
                completion("")
            }
        } failureCallback: { response in
            completion(response.message)
        }
    }

    func register(mobile: String, passWord: String, code: String, completion: @escaping LoginCompletion) {
        AuthenticationAPI.register(mobile: mobile, code: code, passWord: passWord).defaultRequest { jsonData in
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
