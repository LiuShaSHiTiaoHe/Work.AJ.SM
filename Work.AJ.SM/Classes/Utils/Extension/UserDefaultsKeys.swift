//
//  UserDefaultsKeys.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/7.
//

import Foundation
import SwiftyUserDefaults

let ud = Defaults

extension DefaultsKeys {
    //system
    var onboardStatus: DefaultsKey<Bool> { .init("onboardStatus", defaultValue: false) }
    
    //user
    var loginState: DefaultsKey<Bool> { .init("userloginstate", defaultValue: false) }
    var username: DefaultsKey<String?> { .init("username") }
    var userID: DefaultsKey<String?> { .init("userid") }
    var userMobile: DefaultsKey<String?> { .init("userMobile") }
    var userRealName: DefaultsKey<String?> { .init("userRealName") }
    var NIMToken: DefaultsKey<String?> { .init("NIMToken") }
    var password: DefaultsKey<String?> { .init("password") }
    //Store Date
    var userLastLoginDate: DefaultsKey<Date?> { .init("userLastLoginDate") }
    
    //unit
    var currentUnitID: DefaultsKey<Int?> { .init("currentUnitID") }
    
    //Setting
    var bluetoothSignalStrength: DefaultsKey<Int> { .init("BluetoothSignalStrength", defaultValue: 75) }
    var openDoorStyle: DefaultsKey<Int> { .init("openDoorStyle", defaultValue: 2) }//NonStopSend 0 Shake 1 ButtonPress 2
    var personalOpenDoorPasswordStatus: DefaultsKey<Bool> { .init("personalOpenDoorPasswordStatus", defaultValue: false) }
    
    //common control
    var inAppNotification: DefaultsKey<Bool> { .init("inAppNotification", defaultValue: false) }//通知栏显示
    var vibrationAvailable: DefaultsKey<Bool> { .init("vibrationAvailable", defaultValue: false) }//震动
    var ringtoneAvailable: DefaultsKey<Bool> { .init("ringtoneAvailable", defaultValue: false) }//响铃
    var allowVisitorCall: DefaultsKey<Bool> { .init("allowVisitorCall", defaultValue: false) }//允许访客呼叫手机
}
