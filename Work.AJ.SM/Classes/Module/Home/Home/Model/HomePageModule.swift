//
//  HomePageModuleEnum.swift
//  SmartCommunity
//
//  Created by Anjie on 2021/12/31.
//

import Foundation

enum HomePageModule: String {
    case mobileCallElevator = "乘梯选层"
    case ownerQRCode = "一码通"
    case indoorCallElevator = "室内呼梯"
    case bleCallElevator = "蓝牙呼梯/开门"
    case cloudOpenGate = "远程开门"
    case cloudIntercom = "门禁对讲"
    case scanElevatorQRCode = "扫码乘梯"
    case inviteVisitors = "访客邀请"
    case addFamilyMember = "添加家人/成员"
    case deviceConfiguration = "设备配置"
    case elevatorConfiguration = "电梯配置"

    var model: HomePageFunctionModule {
        switch self {
        case .addFamilyMember:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "addFamilyMember", tag: "", index: 9)
        case .deviceConfiguration:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "bleSetting", tag: "MOUDLE10", index: 10)
        case .elevatorConfiguration:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "elevatorConfiguration", tag: "MOUDLE13", index: 13)
        case .mobileCallElevator:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "mobileCallElevator", tag: "MOUDLE12", index: 1)
        case .ownerQRCode:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "ownerQRCode", tag: "MOUDLE16", index: 2)
        case .indoorCallElevator:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "indoorCallElevator", tag: "MOUDLE1", index: 3)
        case .bleCallElevator:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "bleCallElevator", tag: "MOUDLE3", index: 4)
        case .cloudOpenGate:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "cloudOpneGate", tag: "MOUDLE2", index: 5)
        case .cloudIntercom:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "cloudIntercom", tag: "MOUDLE18", index: 6)
        case .scanElevatorQRCode:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "scanElevatorQRCode", tag: "MOUDLE8", index: 7)
        case .inviteVisitors:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "inviteVisitors", tag: "MOUDLE17", index: 8)
        }
    }
}

extension HomePageModule: CaseIterable {
}


struct HomePageFunctionModule {
    var name: String = ""
    var icon: String = ""
    var tag: String = ""
    var index: Int = 0
}
