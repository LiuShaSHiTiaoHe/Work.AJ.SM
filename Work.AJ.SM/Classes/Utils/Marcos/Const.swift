//
//  ConstStrigs.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/7.
//

import Foundation

// MARK: - APP info
let kConstAPPNameString = "安杰智慧社区"
let kAboutUsPageURLString = "http://www.njanjar.com/index.php/Home/Index/about.html"
let kPrivacyPageURLString = "http://www.njanjar.com/smarthome_privacy_statement.html"
let kUserAgreementURLString = "http://www.njanjar.com/user_agreement.html"
let kServiceSupportNumber = "025-52309399"
let kAppID = "1444571864"
let kAppStoreUrl = "https://itunes.apple.com/app/id\(kAppID)"
let kAppInfoLookUpUrl = "http://itunes.apple.com/cn/lookup?id=\(kAppID)"

// MARK: - Third part Sdk info
let kJPushAppKey = "3e191e80c1475843e7204166"
let kAmapKey = "359d74c1fda0ceb00f5c446de2d36ce8"

// MARK: - Device info
let kDeviceType = "iOS"

// MARK: - 声网APPID None token
let kAgoraAppID = "31c87e63d50446baba06c0da8a0c99d9"

// MARK: - Const String
let kDefaultDateFormatter = "yyyy-MM-dd HH:mm:ss"
let kKeyChainServiceKey = "com.anjie.home.keys"
let kDefaultCityName = "南京"

// MARK: - Tips
let kDefaultRemoteOpenDoorTips = "设备离线状态下，无法远程开门和视频通话"

// MARK: - 检查更新时间间隔，获取模块控制时间间隔
// FIXME: - 测试检查更新间隔时间为0 分钟，也就是每次都检查
let kCheckTimeInterval = 5//60 * 24
let kModuleStatusTimeInterval = 5//60 * 24
