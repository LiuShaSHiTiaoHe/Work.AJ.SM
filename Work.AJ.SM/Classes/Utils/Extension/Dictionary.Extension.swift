//
//  Dictionary.Extension.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/2.
//

import Foundation

extension Dictionary where Key: StringProtocol {
    func ekey(_ key: String) -> Dictionary{
        var result = Dictionary().merging(self){ (_ , new ) in
            new
        }
        result.updateValue(key as! Value, forKey: "ekey" as! Key)
        return result
    }
}
