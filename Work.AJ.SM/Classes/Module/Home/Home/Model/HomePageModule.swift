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
    case deviceConfiguration = "设备配置"
    case addFamilyMember = "添加家人/成员"
    case elevatorConfiguration = "电梯配置"
    case ncall = "N方对讲"


    var model: HomePageFunctionModule {
        switch self {

        case .addFamilyMember:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "addFamilyMember", tag: "", index: 9, showinpage: .home)
        case .deviceConfiguration:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "bleSetting", tag: "MOUDLE10", index: 10, showinpage: .home)
        case .elevatorConfiguration:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "elevatorConfiguration", tag: "MOUDLE13", index: 13, showinpage: .home)
        case .mobileCallElevator:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "mobileCallElevator", tag: "MOUDLE12", index: 1, showinpage: .home)
        case .ownerQRCode:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "ownerQRCode", tag: "MOUDLE16", index: 2, showinpage: .home)
        case .indoorCallElevator:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "indoorCallElevator", tag: "MOUDLE1", index: 3, showinpage: .home)
        case .bleCallElevator:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "bleCallElevator", tag: "MOUDLE3", index: 4, showinpage: .home)
        case .cloudOpenGate:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "cloudOpneGate", tag: "MOUDLE2", index: 5, showinpage: .home)
        case .cloudIntercom:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "cloudIntercom", tag: "MOUDLE2", index: 6, showinpage: .home)
        case .scanElevatorQRCode:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "scanElevatorQRCode", tag: "MOUDLE8", index: 7, showinpage: .home)
        case .inviteVisitors:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "inviteVisitors", tag: "MOUDLE17", index: 8, showinpage: .home)
        case .ncall:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "cloudSpeak", tag: "OTHERUSED", index: 13)

        }
    }
}

extension HomePageModule: CaseIterable {
}


enum ShowInPage {
    case home
    case service
    case neighbour
    case unknown
}

struct HomePageFunctionModule {
    var name: String = ""
    var icon: String = ""
    var tag: String = ""
    var index: Int = 0
    var showinpage: ShowInPage = .unknown
}
