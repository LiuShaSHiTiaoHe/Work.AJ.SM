//
//  Permission.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/3/22.
//

import UIKit
import SPPermissions

extension BaseViewController {
    func checkPermission(_ permissions: [SPPermissions.Permission]) {
        permissions.forEach { permission in
            PermissionManager.shared.requestPermission(permission)
        }
    }
}

extension BaseViewController {
    // MARK: - 功能模块开启状态，是否提示升级
    func showModuleVersionControlTipsView(module: ModulesOfModuleStatus, completion: @escaping () -> Void) {
        if HomeRepository.shared.getModuleStatusFromCache(module: module) {
            completion()
        } else {
            let alert = UIAlertController.init(title: "升级提示", message: "您的APP版本过低，已严重影响您使用该功能，请升级至最新版本，点击“下载” \n 注意：升级过程中将无法使用软件 ", preferredStyle: .alert)
            alert.addAction("取消", .cancel) {
                completion()
            }
            alert.addAction("下载", .destructive) {
                JKGlobalTools.updateApp(vc: self, appId: kAppID )
            }
            alert.show()
        }
    }
}
