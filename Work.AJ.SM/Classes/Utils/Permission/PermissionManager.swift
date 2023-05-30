//
//  PermissionManager.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/3/22.
//

import UIKit
import PermissionsKit
import CameraPermission
import BluetoothPermission
import MicrophonePermission
import PhotoLibraryPermission

class PermissionManager {
    static let shared = PermissionManager()

    
    func onBoardPermissionRequest() {
        let view = PermissionRequestView()
        PopViewManager.shared.display(view, .center, .init(width: .constant(value: kScreenWidth - 50), height: .constant(value: 400 + kMargin*2)), true)
    }
    
    func onBoardPermissionRequestDismiss() {
        PopViewManager.shared.dissmiss {}
    }

    static func permissionRequest(_ permission: Permission, _ completion: @escaping (Bool) -> Void) {
        permission.request {
            let authorized = permission.authorized
            completion(authorized)
        }
    }
    
    static func isAllRequestChecked() -> Bool {
        return !Permission.camera.notDetermined && !Permission.bluetooth.notDetermined && !Permission.microphone.notDetermined && !Permission.photoLibrary.notDetermined
    }

    func go2Setting(_ permission: Permission) {
        let alert = UIAlertController.init(title: "\(permission.localisedName)权限已被拒绝", message: "请前往系统设置页面打开相应权限", preferredStyle: .alert)
        alert.addAction("取消", .cancel) {

        }
        alert.addAction("设置", .default) {
            permission.openSettingPage()
        }
        alert.show()
    }

    private init() {}
}

