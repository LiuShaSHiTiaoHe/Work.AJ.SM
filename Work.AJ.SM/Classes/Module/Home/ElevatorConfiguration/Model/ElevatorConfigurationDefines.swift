//
//  ElevatorConfigurationDefines.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/4/8.
//

import UIKit

class ElevatorConfigurationDefines {
    static let shared = ElevatorConfigurationDefines()
    let functions: Array<String> = ["写密码", "写卡片扇区", "写群组号", "写入SN码", "写楼层配置"]
    
    private init() {}
}
