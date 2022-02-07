//
//  HomePageModuleEnum.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2021/12/31.
//

import Foundation

enum HomePageModule: String {
    case ncall = "N方对讲"
    case indoorCall = "室内呼梯"
    case cloudGate = "云门禁"
    case cloudIntercom = "云对讲"
    case inElevatorCall = "轿厢呼梯"
    case bleOpenDoor = "蓝牙开门"
    case propertyBill = "物业账单"
    case contactProperty = "联系物业"
    case declareRepairs = "维修申报"
    case suggestion = "投诉建议"
    case rent = "房屋租赁"
    case samrtParking = "智慧停车"
    case smartHome = "智能家居"
    case scanQR = "扫码乘梯"
    case deviceConfiguration = "设备配置"
    case mobileCallElevator = "手机呼梯"
    case openUnitDoor = "开单元门"
    case emergencyCall = "困人呼叫"
    case qrcode = "一码通"
    case visitorqrcode = "访客邀请"

    var model: HomePageFunctionModule {
        switch self {
        case .indoorCall:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "callLitHouse", tag: "MOUDLE1", index: 0 )
        case .cloudGate:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "cloudMenjin", tag: "MOUDLE2", index: 1 )
        case .cloudIntercom:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "cloudSpeak", tag: "MOUDLE2", index: 2 )
        case .inElevatorCall:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "callLift", tag: "MOUDLE3", index: 3 )
        case .bleOpenDoor:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "bleOpenDoor", tag: "MOUDLE3", index: 4 )
        case .propertyBill:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "zhangDanModule", tag: "MOUDLE4", index: 5 )
        case .contactProperty:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "contactWuye", tag: "MOUDLE4", index: 6 )
        case .declareRepairs:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "weixiuModule", tag: "MOUDLE4", index: 7 )
        case .suggestion:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "advice", tag: "MOUDLE4", index: 8 )
        case .rent:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "houseRent", tag: "MOUDLE4", index: 9 )
        case .samrtParking:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "parking", tag: "MOUDLE5", index: 10 )
        case .smartHome:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "jiajuModule", tag: "MOUDLE6", index: 11 )
        case .scanQR:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "qrCode", tag: "MOUDLE8", index: 12 )
        case .ncall:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "cloudSpeak", tag: "OTHERUSED", index: 13 )
        case .deviceConfiguration:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "bleSetting", tag: "MOUDLE10", index: 14 )
        case .mobileCallElevator:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "cellphonecallelevator", tag: "MOUDLE12", index: 15 )
        case .openUnitDoor:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "openunitdoor", tag: "MOUDLE14", index: 16 )
        case .emergencyCall:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "emergencycall", tag: "MOUDLE15", index: 17 )
        case .qrcode:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "oneQRCode", tag: "MOUDLE16", index: -2 )
        case .visitorqrcode:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "visitorQRCode", tag: "MOUDLE17", index: -1 )
        }
    }
}

extension HomePageModule: CaseIterable {}



struct HomePageFunctionModule {
    var name: String = ""
    var icon: String = ""
    var tag: String = ""
    var index: Int = 0
}
