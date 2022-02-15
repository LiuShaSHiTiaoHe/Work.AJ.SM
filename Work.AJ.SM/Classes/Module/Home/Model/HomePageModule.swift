//
//  HomePageModuleEnum.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2021/12/31.
//

import Foundation

enum HomePageModule: String {
    case mobileCallElevator = "乘梯选层"
    case ownerQRCode = "业主一码通"
    case indoorCallElevator = "室内呼梯"
    case bleCallElevator = "蓝牙呼梯"
    case cloudOpneGate = "远程开门"
    case cloudIntercom = "门禁对讲"
    case scanElevatorQRCode = "扫码乘梯"
    case inviteVisitors = "访客邀请"
    case deviceConfiguration = "设备配置"
    case addFamilyMember = "添加成员"
    
    case ncall = "N方对讲"
    case bleOpenDoor = "蓝牙开门"
    case propertyBill = "物业账单"
    case contactProperty = "联系物业"
    case declareRepairs = "维修申报"
    case suggestion = "投诉建议"
    case rent = "房屋租赁"
    case samrtParking = "智慧停车"
    case smartHome = "智能家居"
    case openUnitDoor = "开单元门"
    case emergencyCall = "困人呼叫"

    var model: HomePageFunctionModule {
        switch self {
        case .mobileCallElevator:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "mobileCallElevator", tag: "MOUDLE12", index: 1, showinpage: .home)
        case .ownerQRCode:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "ownerQRCode", tag: "MOUDLE16", index: 2, showinpage: .home)
        case .indoorCallElevator:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "indoorCallElevator", tag: "MOUDLE1", index: 3, showinpage: .home)
        case .bleCallElevator:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "bleCallElevator", tag: "MOUDLE3", index: 4, showinpage: .home)
        case .cloudOpneGate:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "cloudOpneGate", tag: "MOUDLE2", index: 5, showinpage: .home)
        case .cloudIntercom:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "cloudIntercom", tag: "MOUDLE2", index: 6, showinpage: .home)
        case .scanElevatorQRCode:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "scanElevatorQRCode", tag: "MOUDLE8", index: 7, showinpage: .home)
        case .inviteVisitors:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "inviteVisitors", tag: "MOUDLE17", index: 8, showinpage: .home)
        //MARK: FIXME 暂时显示两个模块，tag写死为2
        case .addFamilyMember:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "addFamilyMember", tag: "MOUDLE2", index: 9, showinpage: .home)
        case .deviceConfiguration:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "bleSetting", tag: "MOUDLE2", index: 10, showinpage: .home)
        

            
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
        case .ncall:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "cloudSpeak", tag: "OTHERUSED", index: 13 )
        case .openUnitDoor:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "openunitdoor", tag: "MOUDLE14", index: 16 )
        case .emergencyCall:
            return HomePageFunctionModule.init(name: self.rawValue, icon: "emergencycall", tag: "MOUDLE15", index: 17 )
        }
    }
}

extension HomePageModule: CaseIterable {}


enum ShowInPage {
    case home
    case service
    case neighbour
    case unkown
}

struct HomePageFunctionModule {
    var name: String = ""
    var icon: String = ""
    var tag: String = ""
    var index: Int = 0
    var showinpage: ShowInPage = .unkown
}
