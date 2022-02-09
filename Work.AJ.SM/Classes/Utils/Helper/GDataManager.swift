//
//  GDataManager.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
import CryptoSwift

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
