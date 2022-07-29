//
//  GDataManager.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/7.
//

import Foundation
import CryptoSwift
import AVFoundation
import SwiftyUserDefaults
import SVProgressHUD
import KeychainAccess

class GDataManager: NSObject {
    static let shared = GDataManager()

    func loginState() -> Bool {
        ud.loginState
    }

    func showLoginView() {
        if let currentVC = UIViewController.currentViewController() {
            let vc = LoginViewController()
            vc.modalPresentationStyle = .fullScreen
            currentVC.present(vc, animated: true, completion: nil)
        }
    }
    
    func setupKeyChain() {
        let keychain = Keychain(service: kKeyChainServiceKey)
        let xbid = keychain["xbid"]
        if  xbid == nil{
            keychain["xbid"] = UUID().uuidString
        }
    }
    
    // MARK: - 初始化realm
    func setupDataBase() {
        if let username = ud.username {
            RealmTools.configRealm(userID: username, schemaVersion: 1)
        }
    }

    // MARK: - JPUSH
    func setupPush(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        #if DEBUG
        JPUSHService.setup(withOption: launchOptions, appKey: kJPushAppKey, channel: "", apsForProduction: false)
        logger.info("JPUSH APS DEBUG")
        #else
        JPUSHService.setup(withOption: launchOptions, appKey: kJPushAppKey, channel: "", apsForProduction: true)
        logger.info("JPUSH APS PRODUCTION")
        #endif
        JPUSHService.setLogOFF()
        JPUSHService.registrationIDCompletionHandler { resCode, registrationID in
            if let registrationID = registrationID {
                logger.info("JPUSH registrationID ===> \(registrationID)")
            }
        }
    }
    
    func pushSetAlias(_ alias: String? = nil) {
        if let alias = alias {
            JPUSHService.setAlias(alias, completion: { iResCode, iAlias, seq in
                if seq != 1 { return }
                if  iResCode != 0 {
                    JPUSHService.deleteAlias({ diResCode, diAlias, dseq in
                        if diResCode == 0 && dseq == 10086 {
                            JPUSHService.setAlias(alias, completion: { iResCode, iAlias, seq in  }, seq: 3)
                        }
                    }, seq: 10086)
                }
            }, seq: 1)
        } else {
            if let mobile = ud.userMobile {
                pushSetAlias(mobile)
            }
        }
    }

    func registerDeviceToken(_ token: Data) {
        JPUSHService.registerDeviceToken(token)
    }
    
    func pushDeleteAlias() {
        JPUSHService.deleteAlias({ iResCode, iAlias, seq in
        }, seq: 2)
    }
    
    // MARK: - 发送视频通话推送给对方，暂时用于户户通。
    func sendVideoCallNotification(_ alias: String) {
        var pushModel = CommonPushModel()
        pushModel.alias = alias
        pushModel.aliasType = "1"
        pushModel.pushFor = "1"
        pushModel.pushType = "1"
        pushModel.type = "videoCall"
        pushModel.title = "智慧社区视频通话"
        let unitName = HomeRepository.shared.getCurrentHouseName()
        if unitName.isNotEmpty {
            pushModel.body = "收到\(unitName)视频通话呼叫请求"
        } else {
            pushModel.body = "收到视频通话呼叫请求，请及时接听..."
        }
        CommonRepository.shared.sendPushNotification(pushModel) { errorMsg in
            logger.info("\(errorMsg)")
        }
    }

    func loginAgoraRtm(){
        guard let kit = AgoraRtm.shared().kit else {
            return
        }
        if let userID = ud.userID {
            // MARK: - Agora Device Account 默认加41前缀，跟门口机设备区分
            let account = userID.ajAgoraAccount()
            kit.login(account: account, token: nil, fail:  { (error) in
                logger.error("AgoraRtm ====> \(error.localizedDescription)")
                SVProgressHUD.showError(withStatus: "error.localizedDescription")
            })
        }
    }

    func logoutAgoraRtm() {
        guard let kit = AgoraRtm.shared().kit else {
            return
        }
        let status = AgoraRtm.shared().status
        if status == .online {
            kit.logOut()
        }
    }

    

    // MARK: - 清除数据
    func clearAccount() {
        pushDeleteAlias()
        RealmTools.deleteRealmFiles()
        removeUserData()
        removeNetCache()
        removeNormalCache()
    }

    // MARK: - 删除用户数据
    func removeUserData() {
        logoutAgoraRtm()
        ud.remove(\.loginState)
        ud.remove(\.username)
        ud.remove(\.userID)
        ud.remove(\.userMobile)
        ud.remove(\.userRealName)
        ud.remove(\.password)
        ud.remove(\.userLastLoginDate)
        ud.remove(\.currentUnitID)
        ud.remove(\.currentCommunityID)
        ud.remove(\.openDoorStyle)
        ud.remove(\.personalOpenDoorPasswordStatus)
        ud.remove(\.getModuleStatusDate)
        ud.remove(\.checkAppVersionDate)
        ud.remove(\.checkedAppVersions)
    }

    // MARK: - 删除网络请求缓存
    func removeNetCache() {
        CacheManager.network.removeAllCache()
    }

    // MARK: - 删除用户日常缓存
    func removeNormalCache() {
        CacheManager.normal.removeAllCache()
    }

    func isOwner() -> Bool {
        if let unit = HomeRepository.shared.getCurrentUnit(), let userType = unit.usertype, userType == "O" {
            return true
        } else {
            return false
        }
    }
}

extension GDataManager {
    func headerMD5(_ dic: Dictionary<String, Any>, _ key: String) -> [String: Any] {
        if dic.has(key), let evalue = dic[key] as? String {
            let timestamp = NSDate().timeIntervalSince1970.jk.string
            let encryptString = evalue + timestamp + "p!P2QklnjGGaZKlw"
            let fkey = encryptString.md5()
            var result = Dictionary().merging(dic) { (_, new) in
                new
            }
            result.updateValue(timestamp, forKey: "TIMESTAMP")
            result.updateValue(fkey, forKey: "FKEY")
            result.removeValue(forKey: "ekey")
            return result
        }
        return dic
    }
}

extension GDataManager {
    func checkAvailableCamera() -> Bool {
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let _ = try AVCaptureDeviceInput.init(device: device)
                return true
            } catch {
                return false
            }
        } else {
            return false
        }
    }
}


extension GDataManager {
    func timeDuration(withInterval time: Int) -> String {
        var result = ""
        let seconds = time % 60
        var minutes = time / 60
        var hours: Int = 0
        if minutes > 60 {
            hours = minutes / 60
            minutes = minutes % 60
        }
        if hours > 0 {
            result = hours.jk.intToString + "小时" + minutes.jk.intToString + "分钟" + seconds.jk.intToString + "秒"
        } else {
            if minutes > 0 {
                result = minutes.jk.intToString + "分种" + seconds.jk.intToString + "秒"
            } else {
                result = seconds.jk.intToString + "秒"
            }
        }

        return result
    }
}
