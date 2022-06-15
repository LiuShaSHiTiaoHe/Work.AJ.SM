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
