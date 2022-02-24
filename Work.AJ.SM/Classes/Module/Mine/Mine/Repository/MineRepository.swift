//
//  MineRepository.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/23.
//

import UIKit

class MineRepository: NSObject {
    static let shared = MineRepository()

    func getMineModules() -> [MineModule] {
        if let unit = HomeRepository.shared.getCurrentUnit() {
            let allKeys = MineModuleType.allCases
            let allModules = allKeys.compactMap {  moduleEnum in
                return moduleEnum.model
            }
            if let otherUsed = unit.otherused, otherUsed == 1 {
                return allModules.filter{$0.isOtherUsed}
            }else{
                return allModules.filter {$0.tag == mineModuleType}
            }
        }
        return []
    }
    
}
