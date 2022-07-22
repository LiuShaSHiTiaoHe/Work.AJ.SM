//
//  AppUpgradeManager.swift
//  Work.AJ.SM
//
//  Created by guguijun on 2022/7/19.
//

import Foundation
import JKSwiftExtension
import SwiftyJSON
import SVProgressHUD

class AppUpgradeManager {
    // FIXME: - 测试检查更新间隔时间为0，也就是每次都检查
    private let checkTimeInterval = 0//60 * 60 * 24//检查更新时间间隔

    static let shared = AppUpgradeManager()
    private init() {}
}

extension AppUpgradeManager {
    // MARK: - 用户手动检查更新
    func checkAppUpdate() {
        MineAPI.versionCheck(type: kDeviceType.lowercased()).defaultRequest { [weak self] jsonData in
            guard let `self` = self else { return }
            self.processVersionCompare(jsonData: jsonData) {version, needUpdate, isForce, releaseNotes, errorMsg in
                if needUpdate {
                    self.showAppUpdateView(releaseNotes: releaseNotes, isForce: isForce)
                } else {
                    SVProgressHUD.showInfo(withStatus: errorMsg)
                }
            }
        } failureCallback: { response in
            SVProgressHUD.showError(withStatus: response.message)
        }
    }
    
    // MARK: - 自动检测更新
    func autoCheckVersion() {
        if isAutoCheckUpdateAvailable() {
            MineAPI.versionCheck(type: kDeviceType.lowercased()).defaultRequest { [weak self] jsonData in
                guard let `self` = self else { return }
                
                self.processVersionCompare(jsonData: jsonData) {version, needUpdate, isForce, releaseNotes, errorMsg in
                    let checkedVersions = ud.checkedAppVersions
                    logger.info("当前版本：\(Bundle.jk.appVersion), 最新版本：\(version)")
                    logger.info("记录的检测过的版本：\(checkedVersions)")
                    if !checkedVersions.isEmpty {
                        // 已记录的检查过的版本，不包含最新的版本号，进行版本的比较。并且记录最新版本，保证下次不再提示。
                        if !checkedVersions.contains(version) {
                            if needUpdate {
                                var temp = Array<String>.init(checkedVersions)
                                temp.append(version)
                                ud.checkedAppVersions = temp
                                self.showAppUpdateView(releaseNotes: releaseNotes, isForce: isForce)
                            } else {
                                logger.info("本地记录不为空，不需要更新，不记录需要更新的版本：\(version)")
                            }
                        } else {
                            logger.info("本地记录不为空，已记录版本：\(version)")
                        }
                    } else {
                        //本地记录为空，进行版本的比较，如果当前版本较低，就提示升级
                        if needUpdate {
                            logger.info("本地记录为空，需要更新，记录需要更新的版本：\(version)")
                            ud.checkedAppVersions = [version]
                            self.showAppUpdateView(releaseNotes: releaseNotes, isForce: isForce)
                        } else {
                            logger.info("本地记录为空，不需要更新，不记录需要更新的版本：\(version)")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - 处理返回数据
    private func processVersionCompare(jsonData: JSON, completion: @escaping (_ vesion: String, _ needUpdate: Bool, _ isForce: Bool, _ releaseNotes: String, _ errorMsg: String) -> Void){
        if let deviceType = jsonData["data"]["TYPE"].string, deviceType.lowercased() == kDeviceType.lowercased(),
            let version = jsonData["data"]["VERSION"].string, self.isVaildAppVersion(version) {
            if JKGlobalTools.compareVersion(version: version) {
                if let needUpgrade = jsonData["data"]["needUpgrade"].string, needUpgrade == "T" {
                    if let isForceUpdate = jsonData["data"]["IFFORCE"].string, isForceUpdate == "T" {
                        if let releaseNotes = jsonData["data"]["releaseNotes"].string {
                            completion(version, true, true, releaseNotes, "")
                        } else {
                            completion(version, true, true, "检测到有新的版本", "")
                        }
                    } else {
                        if let releaseNotes = jsonData["data"]["releaseNotes"].string {
                            completion(version, true, false, releaseNotes, "")
                        } else {
                            completion(version, true, false, "检测到有新的版本", "")
                        }
                    }
                } else {
                    completion(version, false, false, "", "暂无可用新版本")
                }
            } else {
                completion(version, false, false, "", "当前已是最新版本")
            }
        } else {
            completion("", false, false, "", "暂时无法获取最新版本信息，请稍后再试。")
        }
    }
    
    // MARK: - 去App Store检查版本信息。 暂时不使用了
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
    
    // MARK: - 是否在设定的自动检查更新时间端
    private func isAutoCheckUpdateAvailable() -> Bool {
        //暂时保证用户在登录状态去检查更新
        guard let _ = ud.userID else { return false }
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
    
    // MARK: - 版本号是否符合规则 x.x.x
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
    // MARK: - 展示升级提示页面
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
