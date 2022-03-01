//
//  GDataManager.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
import CryptoSwift
import Siren

final class GDataManager {
    static let shared = GDataManager()
    
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
    
    func loginState() -> Bool {
        if let _ = Defaults.username {
            return true
        }
        return false
    }
    
    func setupDataBase() {
        if let username = Defaults.username {
            RealmTools.configRealm(userID: username)
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


extension Dictionary where Key: StringProtocol {
    func ekey(_ key: String) -> Dictionary{
        var result = Dictionary().merging(self){ (_ , new ) in
            new
        }
        result.updateValue(key as! Value, forKey: "ekey" as! Key)
        return result
    }
}
