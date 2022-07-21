//
//  UserDefaultsKeys.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/7.
//

import Foundation
import SwiftyUserDefaults

let ud = Defaults

extension DefaultsKeys {
    // MARK: - system
    var onboardStatus: DefaultsKey<Bool> {
        .init("onboardStatus", defaultValue: false)
    }
    // MARK: - user
    var loginState: DefaultsKey<Bool> {
        .init("userloginstate", defaultValue: false)
    }
    var username: DefaultsKey<String?> {
        .init("username")
    }
    var userID: DefaultsKey<String?> {
        .init("userid")
    }
    var userMobile: DefaultsKey<String?> {
        .init("userMobile")
    }
    var userRealName: DefaultsKey<String?> {
        .init("userRealName")
    }
    var password: DefaultsKey<String?> {
        .init("password")
    }
    // MARK: - Store Date
    var userLastLoginDate: DefaultsKey<Date?> {
        .init("userLastLoginDate")
    }
    // MARK: - APP Update
    // 记录检查更新的时间，固定时间间隔去调用检查更新
    var checkAppVersionDate: DefaultsKey<Date?> {
        .init("checkAppVersionDate")
    }
    // 记录已经检查过的版本(如果已经检查过，在当前的版本，就不去调用检查更新的接口)
    var checkedAppVersions: DefaultsKey<Array<String>> {
        .init("checkedAppVersion", defaultValue: [])
    }

    // MARK: - Unit
    var currentUnitID: DefaultsKey<Int?> {
        .init("currentUnitID")
    }
    
    var currentCommunityID: DefaultsKey<Int?> {
        .init("currentUnitID")
    }

    // MARK: - Setting
    var bluetoothSignalStrength: DefaultsKey<Int> {
        .init("BluetoothSignalStrength", defaultValue: 75)
    }
    //NonStopSend 0 Shake 1 ButtonPress 2
    var openDoorStyle: DefaultsKey<Int> {
        .init("openDoorStyle", defaultValue: 1)
    }
    
    var personalOpenDoorPasswordStatus: DefaultsKey<Bool> {
        .init("personalOpenDoorPasswordStatus", defaultValue: false)
    }

    // MARK: - Common Control
    //通知栏显示
    var inAppNotification: DefaultsKey<Bool> {
        .init("inAppNotification", defaultValue: false)
    }
    //震动
    var vibrationAvailable: DefaultsKey<Bool> {
        .init("vibrationAvailable", defaultValue: false)
    }
    //响铃
    var ringtoneAvailable: DefaultsKey<Bool> {
        .init("ringtoneAvailable", defaultValue: false)
    }
    //允许访客呼叫手机
    var allowVisitorCall: DefaultsKey<Bool> {
        .init("allowVisitorCall", defaultValue: true)
    }
    //用户同步当前房间人脸的提示，只显示一次,记录提示过的房间ID
    var unitIDsOfShownSyncFaceImageNotification: DefaultsKey<Array<String>> {
        .init("showSyncFaceImageNotification", defaultValue: [])
    }
    
    // MARK: - 配置信息
    var appHost: DefaultsKey<String> {
        .init("appHost", defaultValue: "http://120.27.237.7:9393/")
    }
    
    var appServicePath: DefaultsKey<String> {
        .init("appServicePath", defaultValue: "hxcloudplus/")
    }
}
