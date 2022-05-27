//
//  GDataManager.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
import CryptoSwift
import NIMSDK
import AVFoundation
import SwiftyUserDefaults
import SVProgressHUD
import KeychainAccess

class GDataManager: NSObject {
    static let shared = GDataManager()

    func loginState() -> Bool {
        return ud.loginState
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
            RealmTools.configRealm(userID: username)
        }
    }

    // MARK: - 初始化云信
    func setupNIMSDK() {
        let config = NIMSDKConfig.shared()
        config.delegate = self
        config.shouldSyncUnreadCount = true
        config.maxAutoLoginRetryTimes = 10
        config.maximumLogDays = 7
        config.shouldCountTeamNotification = false
        config.animatedImageThumbnailEnabled = false
        let option = NIMSDKOption.init(appKey: kNIMSDKAppKey)
        option.apnsCername = nil
        option.pkCername = nil
        NIMSDK.shared().register(with: option)
    }

    // MARK: - 登陆云信
    func loginNIMSDK() {
        if let mobile = ud.userMobile, let token = ud.NIMToken {
            let account = kNIMSDKPrefixString + mobile
            NIMSDK.shared().loginManager.login(account, token: token) { error in
                if let _ = error {
                    logger.info("云信登录失败")
                } else {
                    logger.info("云信登录成功")
                }
            }
        }
    }

    // MARK: - JPUSH
    func setupPush(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        JPUSHService.setup(withOption: launchOptions, appKey: kJPushAppKey, channel: "", apsForProduction: isProduction)
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
        pushModel.aliasType = "3"
        pushModel.pushFor = "1"
        pushModel.pushType = "1"
        pushModel.type = "videoCall"
        pushModel.title = "智慧社区视频通话"
        pushModel.body = "收到视频通话呼叫请求，请及时接听..."
        CommonRepository.shared.sendPushNotification(pushModel) { errorMsg in
            
        }
    }

    // MARK: - 检查更新
    func checkAppUpdate() {
        MineAPI.versionCheck(type: "ios").defaultRequest { jsonData in
            if let updateStr = jsonData["data"]["IFFORCE"].string, let effectiveStr = jsonData["data"]["EFFECTIVESTATUS"].string {
                if effectiveStr == "T" {
                    if updateStr == "T" {
                        self.checkAppStoreNewVersion(true)
                    } else if updateStr == "F" {
                        self.checkAppStoreNewVersion(false)
                    }
                }
            }
        } failureCallback: { response in
            SVProgressHUD.showError(withStatus: response.message)
        }
    }

    private func checkAppStoreNewVersion(_ force: Bool) {
        VersionCheck.shared.checkNewVersion { hasNewerVersion, versionResult, errorMsg in
            if hasNewerVersion, let versionResult = versionResult {
                let aView = AppUpdateView.init()
                aView.configData(versionResult, force)
                var attributes = EntryKitCustomAttributes.centerFloat.attributes
                attributes.screenInteraction = .absorbTouches
                attributes.scroll = .disabled
                attributes.entryBackground = .color(color: .clear)
                attributes.positionConstraints.size = .init(
                    width: .ratio(value: 0.8),
                    height: .constant(value: 420)
                )
                SwiftEntryKit.display(entry: aView, using: attributes)
            } else {
                SVProgressHUD.showInfo(withStatus: errorMsg)
            }
        }
    }

    

    // MARK: - 清除数据
    func clearAccount() {
        pushDeleteAlias()
        RealmTools.deleteRealmFiles()
        removeUserData()
        removeNetCache()
        removeNomalCache()
    }

    // MARK: - 删除用户数据
    func removeUserData() {
        ud.remove(\.loginState)
        ud.remove(\.username)
        ud.remove(\.userID)
        ud.remove(\.userMobile)
        ud.remove(\.userRealName)
        ud.remove(\.password)
        ud.remove(\.userLastLoginDate)
        ud.remove(\.currentUnitID)
        ud.remove(\.openDoorStyle)
        ud.remove(\.personalOpenDoorPasswordStatus)
    }

    // MARK: - 删除网络请求缓存
    func removeNetCache() {
        CacheManager.network.removeAllCache()
    }

    // MARK: - 删除用户日常缓存
    func removeNomalCache() {
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


extension GDataManager: NIMSDKConfigDelegate {

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
