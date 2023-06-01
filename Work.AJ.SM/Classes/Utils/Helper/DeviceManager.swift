//
//  DeviceManager.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/5/7.
//

import DeviceKit
import Foundation
import JKSwiftExtension
import KeychainAccess

class DeviceManager {
    static let shared = DeviceManager()

    func requestHeaderXDeviceString() -> String {
        let currentDevice = Device.current
        let identifierID = Keychain(service: kKeyChainServiceKey)["xbid"] ?? ""
        var deviceInfo: [String: String] = [:]
        deviceInfo.updateValue(kDeviceType, forKey: "deviceType")
        deviceInfo.updateValue(identifierID, forKey: "deviceId")
        deviceInfo.updateValue(currentDevice.name ?? "", forKey: "deviceName")
        deviceInfo.updateValue(currentDevice.systemVersion ?? "", forKey: "sysVersion")
        deviceInfo.updateValue(NSLocale.current.languageCode ?? "", forKey: "sysLang")
        deviceInfo.updateValue(currentDevice.localizedModel ?? "", forKey: "brandModel")
        deviceInfo.updateValue(TimeZone.current.description, forKey: "timeZone")
        deviceInfo.updateValue(currentDevice.ppi?.jk.intToString ?? "", forKey: "screenResolution")
        if let jsonString = deviceInfo.toJSON(), let base64String = jsonString.jk.base64Encode {
            return base64String
        }
        return ""
    }

    private init() {}
}
