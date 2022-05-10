//
//  MineModel.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/24.
//

import UIKit

//MARK: FIXME 暂时写死设置的模块，用这进行过滤
let mineModuleType = "mineModuleType"

enum MineModuleType: String {
    case house = "我的房屋"
    case faceCertification = "人脸认证"
    case memeberManager = "成员管理"
    case visitorRecord = "访客记录"
    case setting = "通用设置"
    case opendoorSetting = "开门设置"
    case videoCall = "户户通"
    
    case activateCard = "激活蓝牙卡"
    case contactProperty = "联系物业"
    
    case passRecord = "通行记录"
    case opendoorPassword = "开门密码"
    
    var model: MineModule {
        switch self {
        case .house:
            return MineModule.init(name: self.rawValue, icon: "mine_icon_house", tag: mineModuleType, index: 0, destination: .mine_0, isOtherUsed: true)
        case .memeberManager:
            return MineModule.init(name: self.rawValue, icon: "mine_icon_member", tag: mineModuleType, index: 1, destination: .mine_0)
        case .visitorRecord:
            return MineModule.init(name: self.rawValue, icon: "mine_icon_record", tag: mineModuleType, index: 2, destination: .mine_0)
        case .videoCall:
            return MineModule.init(name: self.rawValue, icon: "setting_icon_phone", tag: mineModuleType, index: 3, destination: .mine_0)
        case .faceCertification:
            return MineModule.init(name: self.rawValue, icon: "mine_icon_face", tag: mineModuleType, index: 0, destination: .mine_1)
        case .opendoorSetting:
            return MineModule.init(name: self.rawValue, icon: "mine_icon_opendoor", tag: mineModuleType, index: 1, destination: .mine_1)
        case .setting:
            return MineModule.init(name: self.rawValue, icon: "mine_icon_common", tag: mineModuleType, index: 2, destination: .mine_1, isOtherUsed: true)
            
        case .activateCard:
            return MineModule.init(name: self.rawValue, icon: "", tag: mineModuleType, index: 0, destination: .mine_2)
        case .contactProperty:
            return MineModule.init(name: self.rawValue, icon: "mine_contactProperty_icon", tag: mineModuleType, index: 1, destination: .mine_2)
        
            
        case .opendoorPassword:
            return MineModule.init(name: self.rawValue, icon: "", tag: "", index: 0, destination: .unkown)
        case .passRecord:
            return MineModule.init(name: self.rawValue, icon: "", tag: "", index: 0, destination: .unkown)
        }
    }
}


extension MineModuleType: CaseIterable {}


enum MineModuleDestination {
    case mine_0//section 0
    case mine_1//section 1
    case mine_2//section 2
    case setting
    case unkown
}

struct MineModule {
    var name: String = ""
    var icon: String = ""
    var tag: String = ""
    var index: Int = 0
    var destination: MineModuleDestination = .unkown
    var isOtherUsed: Bool = false
}
