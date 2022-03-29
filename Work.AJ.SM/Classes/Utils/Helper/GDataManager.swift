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

class GDataManager: NSObject {
    static let shared = GDataManager()
    
    func loginState() -> Bool {
        if let _ = Defaults.username {
            return true
        }
        return false
    }
    // MARK: - 初始化realm
    func setupDataBase() {
        if let username = ud.username {
            RealmTools.configRealm(userID: username)
        }
    }
    // MARK: - 初始化云信
    func setupNIMSDK(){
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
        NIMSDK.shared().enableConsoleLog()
    }
    
    // MARK: - 登陆云信
    func loginNIMSDK() {
        if let mobile = ud.userMobile, let token = ud.NIMToken {
            let account = "AJPLUS" + mobile
            NIMSDK.shared().loginManager.login(account, token: token) { error in
                if let _ = error {
                    logger.info("云信登录失败")
                }else{
                    logger.info("云信登录成功")
                }
            }
        }
    }
    
    func checkAppStoreVersion(_ force: Bool, _ frequency: Rules.UpdatePromptFrequency) {
        let siren = Siren.shared
        siren.apiManager = APIManager.init(countryCode: "cn")
        if force {
            let rule = Rules.init(promptFrequency: frequency, forAlertType: .force)
            siren.rulesManager = RulesManager(globalRules: rule)
        }else {
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
                logger.info(error.localizedDescription)
            }
        }
    }
}

extension GDataManager {
    func headerMD5(_ dic: Dictionary<String, Any>, _ key: String) -> [String: Any] {
        if dic.has(key), let evalue = dic[key] as? String {
            let timestamp = NSDate().timeIntervalSince1970.jk.string//NSDate().timeIntervalSince1970.int.string
            let encryptString = evalue + timestamp + "p!P2QklnjGGaZKlw"
            let fkey = encryptString.md5()
            var result = Dictionary().merging(dic){ (_, new) in new }
            result.updateValue(timestamp, forKey: "TIMESTAMP")
            result.updateValue(fkey, forKey: "FKEY")
            result.removeValue(forKey: "ekey")
            return result
        }
        return dic
    }
}


extension GDataManager: NIMSDKConfigDelegate {
    
}

extension Dictionary where Key: StringProtocol {
    func ekey(_ key: String) -> Dictionary{
        var result = Dictionary().merging(self){ (_ , new ) in
            new
        }
        result.updateValue(key as! Value, forKey: "ekey" as! Key)
        return result
    }
}
