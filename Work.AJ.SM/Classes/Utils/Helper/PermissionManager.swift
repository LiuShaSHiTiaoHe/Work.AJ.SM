//
//  PermissionManager.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/3/22.
//

import UIKit
import SPPermissions

class PermissionManager {
    static let shared = PermissionManager()

    func requestAllPermission() {
        requset([.bluetooth, .camera, .microphone])
    }

    static func PermissionRequest(_ permisson: SPPermissions.Permission, _ completion: @escaping (Bool) -> Void) {
        permisson.request {
            let authorized = permisson.authorized
            completion(authorized)
        }
    }

    @discardableResult
    func requestPermission(_ permission: SPPermissions.Permission) -> SPPermissions.PermissionStatus {
        let status = permission.status
        switch status {
        case .authorized:
            break
        case .denied:
            go2Setting(permission)
        case .notDetermined:
            requset([permission])
        case .notSupported:
            break
        }
        return status
    }

    private func requset(_ permissions: [SPPermissions.Permission]) {
        if permissions.count == 1 {
            if let topViewController = UIViewController.jk.topViewController() {
                let controller = SPPermissions.native(permissions)
                controller.delegate = self
                controller.dataSource = self
                controller.present(on: topViewController)
            }
        } else {
            if let topViewController = UIViewController.jk.topViewController() {
                let controller = SPPermissions.dialog(permissions)
                controller.showCloseButton = true
                controller.delegate = self
                controller.dataSource = self
                controller.present(on: topViewController)
            }
        }

    }

    private func go2Setting(_ permission: SPPermissions.Permission) {
        let alert = UIAlertController.init(title: "\(permission.type.name)权限已被拒绝", message: "请前往系统设置页面打开相应权限", preferredStyle: .alert)
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

extension PermissionManager: SPPermissionsDelegate {

    func didHidePermissions(_ permissions: [SPPermissions.Permission]) {
    }

    func didAllowPermission(_ permission: SPPermissions.Permission) {
    }

    func didDeniedPermission(_ permission: SPPermissions.Permission) {
    }
}

extension PermissionManager: SPPermissionsDataSource {
    func configure(_ cell: SPPermissionsTableViewCell, for permission: SPPermissions.Permission) {
        var description = ""
        switch permission {
        case .photoLibrary:
            description = "使用相册进行本地二维码扫描、头像上传、物业报修图片上传等功能"
        case .camera:
            description = "使用相机进行视频通话、头像上传、物业报修图片上传、二维码扫描等功能"
            cell.permissionIconView.setCustomImage(R.image.permission_camera_icon()!)
        case .bluetooth:
            description = "使用蓝牙权限进行远程呼梯，远程开门等功能"
//        case .locationWhenInUse:
//            description = "使用位置信息能更好的定位您所在的小区信息"
        case .microphone:
            description = "使用麦克风进行音频通话"
            cell.permissionIconView.setCustomImage(R.image.permission_microphone_icon()!)
        default:
            break
        }
        cell.permissionDescriptionLabel.text = description
        cell.permissionDescriptionLabel.font = k14Font
    }

    func deniedAlertTexts(for permission: SPPermissions.Permission) -> SPPermissionsDeniedAlertTexts? {
        let texts = SPPermissionsDeniedAlertTexts()
        texts.titleText = "权限已被拒绝"
        texts.descriptionText = "请前往系统设置页面打开相应权限"
        texts.actionText = "设置"
        texts.cancelText = "取消"
        return texts
    }
}
