//
//  PermissionManager.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/3/22.
//

import UIKit
import PermissionsKit
//import SPPermissions

class PermissionManager {
    static let shared = PermissionManager()

    
    func onBoardPermissionRequest() {
        let view = PermissionRequestView()
        PopViewManager.shared.display(view, .center, .init(width: .constant(value: kScreenWidth - 50), height: .constant(value: 400)), true)
    }
    
    
    
    
//    func requestAllPermission() {
//        request([.bluetooth, .camera, .microphone, .photoLibrary])
//    }

    static func permissionRequest(_ permission: Permission, _ completion: @escaping (Bool) -> Void) {
        permission.request {
            let authorized = permission.authorized
            completion(authorized)
        }
    }


//    private func request(_ permissions: [Permission]) {
//        if permissions.count == 1 {
//            if let topViewController = UIViewController.jk.topViewController() {
//                let controller = PermissionsKit.native(permissions)
//                controller.delegate = self
//                controller.dataSource = self
//                controller.present(on: topViewController)
//            }
//        } else {
//            if let topViewController = UIViewController.jk.topViewController() {
//                let controller = PermissionsKit.dialog(permissions)
//                controller.showCloseButton = true
//                controller.delegate = self
//                controller.dataSource = self
//                controller.present(on: topViewController)
//            }
//        }
//    }

    func go2Setting(_ permission: Permission) {
        let alert = UIAlertController.init(title: "\(permission.localisedName)权限已被拒绝", message: "请前往系统设置页面打开相应权限", preferredStyle: .alert)
        alert.addAction("取消", .cancel) {

        }
        alert.addAction("设置", .default) {
            permission.openSettingPage()
        }
        alert.show()
    }

    private init() {
    }
}

