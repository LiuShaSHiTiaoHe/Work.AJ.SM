//
//  GDataManager.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
import CryptoSwift
import Siren
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

    func pushSetAlias(_ alias: String) {
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
    }

    func registerDeviceToken(_ token: Data) {
        JPUSHService.registerDeviceToken(token)
    }
    
    func pushDeleteAlias() {
        JPUSHService.deleteAlias({ iResCode, iAlias, seq in
        }, seq: 2)
    }

    // MARK: - 检查更新
    func checkAppUpdate() {
        MineAPI.versionCheck(type: "ios").defaultRequest { jsonData in
            if let updateStr = jsonData["data"]["IFFORCE"].string, let effectiveStr = jsonData["data"]["EFFECTIVESTATUS"].string {
                if effectiveStr == "T" {
                    if updateStr == "T" {
                        GDataManager.shared.checkAppStoreVersion(true, .immediately)
                    } else if updateStr == "F" {
                        GDataManager.shared.checkAppStoreVersion(false, .immediately)
                    }
                }
            }
        } failureCallback: { response in
            SVProgressHUD.showError(withStatus: response.message)
        }
    }


    private func checkAppStoreVersion(_ force: Bool, _ frequency: Rules.UpdatePromptFrequency) {
        let siren = Siren.shared
        siren.apiManager = APIManager.init(countryCode: "cn")
        if force {
            let rule = Rules.init(promptFrequency: frequency, forAlertType: .force)
            siren.rulesManager = RulesManager(globalRules: rule)
        } else {
            let rule = Rules.init(promptFrequency: frequency, forAlertType: .option)
            siren.rulesManager = RulesManager(globalRules: rule)
        }
        siren.presentationManager = PresentationManager(alertTintColor: R.color.themeColor(),
                appName: Bundle.jk.appDisplayName,
                forceLanguageLocalization: .chineseSimplified)
        siren.wail(performCheck: .onDemand) { results in
            switch results {
            case .success(let updateResults):
                logger.info(updateResults.localization)
            case .failure(let error):
                switch error {
                case .appStoreOSVersionUnsupported:
                    SVProgressHUD.showError(withStatus: "当前手机系统不支持最新版本。")
                case .noUpdateAvailable:
                    SVProgressHUD.showSuccess(withStatus: "当前已是最新版本。")
                default:
                    SVProgressHUD.showError(withStatus: "检查更新失败。")
                }
                logger.info(error.localizedDescription)
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
