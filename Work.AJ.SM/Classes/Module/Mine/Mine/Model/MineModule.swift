//
//  MineModel.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/24.
//

import UIKit

let mineModuleType = "mineModuleType"

enum MineModuleType: String {
    case house = "我的房屋"
    case faceCertification = "人脸认证"
    case memberManager = "成员管理"
    case visitorRecord = "访客记录"
    case setting = "通用设置"
    case opendoorSetting = "开门设置"
    case videoCall = "户户通"
    case activateCard = "激活蓝牙卡"
    case contactProperty = "联系物业"

    case userQRCode = "用户码"
    case gusetQRCode = "访客二维码"
    
    var model: MineModule {
        switch self {
        case .house:
            return MineModule.init(name: self.rawValue, icon: "mine_icon_house", tag: mineModuleType, index: 0, destination: .mine_0, isOtherUsed: true)
        case .memberManager:
            return MineModule.init(name: self.rawValue, icon: "mine_icon_member", tag: mineModuleType, index: 1, destination: .mine_0)
        case .visitorRecord:
            return MineModule.init(name: self.rawValue, icon: "mine_icon_record", tag: mineModuleType, index: 2, destination: .mine_0)
        case .videoCall:
            return MineModule.init(name: self.rawValue, icon: "mine_icon_communication", tag: mineModuleType, index: 3, destination: .mine_0)
        case .faceCertification:
            return MineModule.init(name: self.rawValue, icon: "mine_icon_face", tag: mineModuleType, index: 0, destination: .mine_1)
        case .opendoorSetting:
            return MineModule.init(name: self.rawValue, icon: "mine_icon_opendoor", tag: mineModuleType, index: 1, destination: .mine_1)
        case .setting:
            return MineModule.init(name: self.rawValue, icon: "mine_icon_common", tag: mineModuleType, index: 2, destination: .mine_1, isOtherUsed: true)
        case .contactProperty:
            return MineModule.init(name: self.rawValue, icon: "mine_icon_property", tag: mineModuleType, index: 1, destination: .mine_2)
        case .activateCard:
            return MineModule.init(name: self.rawValue, icon: "", tag: mineModuleType, index: 0, destination: .mine_2)
        case .userQRCode:
            return MineModule.init(name: self.rawValue, icon: "mine_icon_useridentify", tag: mineModuleType, index: 4, destination: .mine_0)
        case .gusetQRCode:
            return MineModule.init(name: self.rawValue, icon: "mine_icon_inviteguest", tag: mineModuleType, index: 5, destination: .mine_0)
        }
    }
}


extension MineModuleType: CaseIterable {}


enum MineModuleDestination {
    case mine_0//section 0
    case mine_1//section 1
    case mine_2//section 2
    case setting
    case unknown
}

struct MineModule {
    var name: String = ""
    var icon: String = ""
    var tag: String = ""
    var index: Int = 0
    var destination: MineModuleDestination = .unknown
    var isOtherUsed: Bool = false
}
