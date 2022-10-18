//
//  NotificationName.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/7.
//

import Foundation

extension Notification.Name {
    // MARK: - 生物识别
    static let kUserBioMetricesStateChanged = Notification.Name("userBioMetricesStateChanged")
    // MARK: - 当前小区切换
    static let kCurrentUnitChanged = Notification.Name("kCurrentUnitChanged")
    // MARK: - 切换到蓝牙自动开门
    static let kSendAutoOpenDoor = Notification.Name("SendAutoOpenDoorNotification")
    // MARK: - 用户更新头像
    static let kUserUpdateAvatar = Notification.Name("UserUpdateAvatar")
    // MARK: - 用户更新开门密码
    static let kUserUpdateOpenDoorPassword = Notification.Name("UserUpdateOpenDoorPassword")
    // MARK: - 添加房屋
    static let kUserAddNewHouse = Notification.Name("EmptyViewAddNewHouse")
    // MARK: - 用户更新系统权限
    static let kUserPermissionStatusChanged = Notification.Name("UserPermissionAuthorizeStatusChanged")

}
