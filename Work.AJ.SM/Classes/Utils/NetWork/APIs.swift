//
//  APIs.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/7.
//

import Foundation

// MARK: - 测试地址  "http://47.111.8.231:9091/"
// MARK: - 线上地址  "http://120.27.237.7:9393/"

func ApiBaseUrl() -> String {
    return ud.appHost + ud.appServicePath
}

final class APIs {       
    
    // MARK: - 基础
    static let versionCheck = "appcity/getAppversion.do"
    static let notice = "appcity/getNotice.do"
    static let advertisement = "appcity/getAdByPosition.do"
    static let notificationStatus = "appcity/getMyNoDisturbTime.do"
    static let updateNotificationStatus = "appcity/addMyNoDisturbTime.do"
    static let propertyContactList = "appcity/getContact.do"
    static let messageList = "appcity/getMyMessage.do"
    static let commonPush = "appDevice/commonPush"
    
    // MARK: - 用户鉴权
    static let login = "appcity/login.do"
    static let register = "appcity/register.do"
    static let msgCode = "appcity/getMessageCode.do"
    static let checkMsgCode = "appcity/checkMessageCode.do"
    static let resetPassword = "appcity/resetPassword.do"
    static let editPassword = "appcity/editPassword.do"
    static let deleteAccount = "appcity/delMyself"

    // MARK: - 用户信息
    static let updateUserInfo = "appcity/perfectAppUser"
    static let updateAvatar = "appcity/addUserHeader.do"
    static let getUserInfo = "/appcity/getUserInfo"

    // MARK: - 房屋
    static let userUnit = "appcity/getMyUnit.do"
    static let allCity = "appcity/getCity.do"
    static let userCommunity = "appcity/getCommunity.do"
    static let userBlock = "appcity/getBlock.do"
    static let userCell = "appcity/getCell.do"
    static let allUnit = "appcity/getUnit.do"
    static let deleteUserUnit = "appcity/deleteMyUnit.do"
    static let houseAuthentication = "appcity/authentication.do"
    static let ownerOpenDoorPassword = "appcity/setMyUnitOpenDoorMM.do"
    static let findUnit = "appcity/findUnit.do"
    static let searchUnitWithName = "/appcity/getCommunityByName"

    // MARK: - 根据单元电梯群组获取电梯
    static let cellGroupElevators = "appcity/getLiftByCellGroup"
    static let floorsBySN = "appcity/getFloorsByLiftsn.do"
    static let locks = "appcity/getLock.do"
    static let openDoor = "appcity/openDoorByAliyun.do"
    static let indoorCallElevator = "appSend2device/landing.do"

    // MARK: - 获取二维码信息
    static let userQRCode = "appcity/createOfflineQrcode"

    // MARK: - 访客
    static let visitors = "appcity/getMyGuest.do"
    static let generateVisitorPassword = "appcity/reduceGuestPassword.do"
    static let updateVisitorPassword = "appcity/updateGuestStatus.do"
    static let inviteVisitor = "appcity/inviteUser.do"
    static let myUnitGuest = "/appcity/getMyUnitGuest"

    // MARK: - 业主添加家属
    static let addFamilyMember = "appcity/addFamilyer"
    static let unitMembers = "appcity/getUnitUsers"
    static let deleteUnitMembers = "appcity/delUnitUser"

    // MARK: - 人脸
    static let faceFile = "appcity/getFaceFile.do"
    static let addFaceFile = "appcity/addFaceFile.do"
    static let deleteFaceFile = "appcity/delFaceFile.do"
    static let extraFaceFile = "appcity/getExtraFaceFile"
    static let syncExtraFaceFile = "appcity/synExtraFaceFile"
    
    // MARK: - 通话
    static let pushApp = "appDevice/pushApp.do"
    static let videoCallPushNotice = "appDevice/pushNoticeToIOS.do"

    // MARK: - 记录
    static let openDoorRecord = "appcity/findAccess.do"

    // MARK: - 电梯配置
    static let elevatorConfiguration = "appcity/getLiftConfigByCellGroup"

    // MARK: - N方对讲
    static let checkNCallSupport = "apphxUnitAuthorities/judgeNcomUtil"
    static let allDTUInfo = "appajNcomUser/appFindDtus.do"
    static let sendNCallStatus = "appajNcomUser/addNcomCallLog.do"
    static let allNCallRecord = "appajNcomUser/findNcomCallLog.do"
    
    // MARK: - Agora
    static let getAgoraRtmToken = "/agora/getRtmToken"
    static let getAgoraRtcToken = "/agora/getRtcToken"

}
