//
//  AppUpgradeManager.swift
//  Work.AJ.SM
//
//  Created by guguijun on 2022/7/19.
//

import Foundation
import JKSwiftExtension

class AppUpgradeManager {
    private let checkTimeInterval = 0//60 * 60 * 24//检查更新时间间隔

    static let shared = AppUpgradeManager()
    private init() {}
}

extension AppUpgradeManager {
    // MARK: - 检查更新
    func checkAppUpdate() {
        MineAPI.versionCheck(type: "ios").defaultRequest { jsonData in
            if let updateStr = jsonData["data"]["IFFORCE"].string, let effectiveStr = jsonData["data"]["EFFECTIVESTATUS"].string {
                if effectiveStr == "T" {
                    if updateStr == "T" {
                        self.checkAppStoreNewVersion(true)
                    } else if updateStr == "F" {
                        self.checkAppStoreNewVersion(false)
                    }
                }
            }
        } failureCallback: { response in
            SVProgressHUD.showError(withStatus: response.message)
        }
    }

    private func checkAppStoreNewVersion(_ force: Bool) {
        VersionCheck.shared.checkNewVersion { hasNewerVersion, versionResult, errorMsg in
            if hasNewerVersion, let versionResult = versionResult {
                DispatchQueue.main.async {
                    self.showAppUpdateView(releaseNotes: versionResult.releaseNotes ?? "", isForce: force)
                }
            } else {
                SVProgressHUD.showInfo(withStatus: errorMsg)
            }
        }
    }
    
    // MARK: - 自动检测更新
    func autoCheckVersion() {
        if isAutoCheckUpdateAvailable() {
            MineAPI.versionCheck(type: kDeviceType.lowercased()).defaultRequest { [weak self] jsonData in
                guard let `self` = self else { return }
                if let deviceType = jsonData["data"]["TYPE"].string, deviceType.lowercased() == kDeviceType.lowercased(),
                   let latestAppVersion = jsonData["data"]["VERSION"].string, self.isVaildAppVersion(latestAppVersion) {
                    let checkedVersions = ud.checkedAppVersions
                    logger.info("当前版本：\(Bundle.jk.appVersion), 最新版本：\(latestAppVersion)")
                    logger.info("记录的检测过的版本：\(checkedVersions)")
                    if !checkedVersions.isEmpty {
                        if !checkedVersions.contains(latestAppVersion) {
                            var udVersions = Array<String>()
                            udVersions.append(contentsOf: checkedVersions)
                            udVersions.append(latestAppVersion)
                            ud.checkedAppVersions = udVersions
                            if JKGlobalTools.compareVersion(version: latestAppVersion) {

                            } else {
                                self.showAppUpdateView(releaseNotes: "", isForce: false)
                            }
                        }
                    } else {
                        ud.checkedAppVersions = [latestAppVersion]
                        self.showAppUpdateView(releaseNotes: "", isForce: false)
                    }
                }
            }
        }
    }
    
    private func isAutoCheckUpdateAvailable() -> Bool {
        guard let lastCheckDate = ud.checkAppVersionDate else {
            ud.checkAppVersionDate = Date()
            logger.info("最近一次检查更新时间为空，更新为当前日期 \(Date().jk.toformatterTimeString())")
            return true
        }
        logger.info("上次检查更新时间====\(lastCheckDate.jk.toformatterTimeString()), 当前时间：\(Date().jk.toformatterTimeString())")
        if let intervalMinites = lastCheckDate.jk.numberOfMinutes(from: Date()) {
            logger.info("距离上次检查更新已经: \(abs(intervalMinites)) 分钟")
            if abs(intervalMinites) > checkTimeInterval {
                ud.checkAppVersionDate = Date()
                return true
            }
        }
        return false
    }
    
    private func isVaildAppVersion(_ version: String) -> Bool {
        let versionArray = version.jk.separatedByString(with: ".")
        guard versionArray.count == 3, let versionString1 = versionArray[0] as? String, let versionString2 = versionArray[1] as? String, let versionString3 = versionArray[2] as? String else {
            return false
        }
        guard let _ = versionString1.jk.toInt(), let _ = versionString2.jk.toInt(), let _ = versionString3.jk.toInt() else {
            return false
        }
        return true
    }
    
    private func showAppUpdateView(releaseNotes: String, isForce: Bool) {
        let aView = AppUpdateView.init()
        aView.configData(releaseNotes, isForce)
        var attributes = EntryKitCustomAttributes.centerFloat.attributes
        attributes.screenInteraction = .absorbTouches
        attributes.scroll = .disabled
        attributes.entryBackground = .color(color: .clear)
        attributes.positionConstraints.size = .init(
            width: .ratio(value: 0.8),
            height: .constant(value: 420)
        )
        SwiftEntryKit.display(entry: aView, using: attributes)
    }
}
