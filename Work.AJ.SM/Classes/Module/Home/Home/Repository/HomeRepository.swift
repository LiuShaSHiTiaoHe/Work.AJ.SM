//
//  HomeDataManager.swift
//  Work.AJ.SM
//
//  Created by Anjie on 2022/2/8.
//

import Foundation
import SVProgressHUD
import JKSwiftExtension

typealias HomeModulesCompletion = ([HomePageFunctionModule]) -> Void
typealias HomeAdsAndNoticeCompletion = ([AdsModel], [NoticeModel]) -> Void
typealias HomeDataCompletion = ([HomePageFunctionModule], [AdsModel], [NoticeModel], UnitStatus) -> Void
typealias HomeAllLocksCompletion = ([UnitLockModel]) -> Void
typealias ElevatorConfigurationCompletion = (ElevatorConfiguration?) -> Void
typealias AgoraTokenCompletion = (String) -> Void
// MARK: - NCom
typealias NComAllDeviceInfoCompletion = ([NComDTU]) -> Void
typealias NComCallRecordCompletion = ([NComRecordInfo], Int) -> Void

class HomeRepository {
    static let shared = HomeRepository()

}

// MARK: - SpecificPageNotice
extension HomeRepository {
    func getSpecificPageNotice(with pageID: String, completion: @escaping (_ errorMsg: String, _ notice: String) -> Void) {
        if let unit = getCurrentUnit(), let userID = ud.userID, let communityID = unit.communityid?.jk.intToString {
            HomeAPI.getSpecificPageNotice(pageID: pageID, communityID: communityID, userID: userID).defaultRequest(cacheType: .networkElseCache,
                    showError: false, successCallback: { json in
                        if let dataJson = json["data"].dictionary, let message = dataJson["msg"]?.string {
                            completion("", message)
                        }
                    }, failureCallback: { response in
                            completion(response.message, "")
                    })
        }
    }
}

// MARK: - locks
extension HomeRepository {

    func getCurrentLocks() -> [UnitLockModel] {
        var result = [UnitLockModel]()
        if let unit = getCurrentUnit() {
            let locks = unit.locks
            result.append(contentsOf: locks.filter({ model in
                model.locktype != "B"
            }))
        }
        return result
    }

    func getAllLocks(completion: @escaping HomeAllLocksCompletion) {
        if let unit = getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let cellID = unit.cellid?.jk.intToString, let unitID = unit.unitid?.jk.intToString, let userID = ud.userID {
            HomeAPI.getLocks(communityID: communityID, blockID: blockID, cellID: cellID, unitID: unitID, userID: userID, physicfloor: "").request(modelType: [UnitLockModel].self, cacheType: .networkElseCache, showError: true) { models, response in
                completion(models)
            } failureCallback: { response in
                completion([])
            }
        }
    }

    func openDoorViaPush(_ lockMac: String, completion: @escaping DefaultCompletion) {
        if let userID = ud.userID, let unit = getCurrentUnit(), let physicalFloor = unit.physicalfloor, let communityID = unit.communityid?.jk.intToString, let unitID = unit.unitid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let cellID = unit.cellid?.jk.intToString {
            HomeAPI.openDoor(lockMac: lockMac, userID: userID, communityID: communityID, blockID: blockID, unitID: unitID, cellID: cellID, physicalFloor: physicalFloor).defaultRequest { jsonData in
                completion("")
            } failureCallback: { response in
                completion(response.message)
            }
        } else {
            completion("数据错误")
        }
    }
}

// MARK: - indoorCallElevator
extension HomeRepository {
    func callElevatorViaMobile(direction: String, completion: @escaping DefaultCompletion) {
        if let unit = getCurrentUnit(), let cellID = unit.cellid?.jk.intToString, let physicalFloor = unit.physicalfloor, let unitNo = unit.unitno {
            HomeAPI.callElevatorViaMobile(cellID: cellID, direction: direction, physicalFloor: physicalFloor, unitNo: unitNo).defaultRequest { jsonData in
                completion("")
            } failureCallback: { response in
                completion(response.message)
            }
        } else {
            completion("数据错误")
        }
    }
}

// MARK: - 配置
extension HomeRepository {
    func getElevatorConfiguration(completion: @escaping ElevatorConfigurationCompletion) {
        if let unit = getCurrentUnit(), let communityID = unit.communityid?.jk.intToString {
            HomeAPI.getElevatorConfiguration(communityID: communityID).request(modelType: ElevatorConfiguration.self, cacheType: .ignoreCache, showError: true) { model, response in
                completion(model)
            } failureCallback: { response in
                completion(nil)
            }
        }
    }
}

// MARK: - N方对讲
extension HomeRepository {
    func allNComDeviceInfo(completion: @escaping NComAllDeviceInfoCompletion) {
        if let unit = getCurrentUnit(), let unitID = unit.unitid?.jk.intToString {
            HomeAPI.ncomAllDevice(unitID: unitID).request(modelType: [NComDTU].self, cacheType: .ignoreCache, showError: true) { models, response in
                completion(models)
            } failureCallback: { response in
                completion([])
            }
        }
    }

    func loadNComRecord(_ sTime: String = "", _ eTime: String = "", _ page: String, _ count: String = "15", completion: @escaping NComCallRecordCompletion) {
        if let unit = getCurrentUnit(), let communityID = unit.communityid?.jk.intToString {
            HomeAPI.ncomRecord(communityID: communityID, startTime: sTime, endTime: eTime, page: page, count: count).defaultRequest { jsonData in
                if let recordsData = jsonData["data"].rawString(), let records = [NComRecordInfo](JSONString: recordsData) {
                    if let pageData = jsonData["page"].dictionaryObject, let tPage = pageData["totalPage"] as? Int {
                        completion(records, tPage)
                    } else {
                        completion([], -1)
                    }
                } else {
                    if let pageData = jsonData["page"].dictionaryObject, let tPage = pageData["totalPage"] as? Int {
                        completion([], tPage)
                    } else {
                        completion([], -1)
                    }
                }
            }
        }
    }
}

extension HomeRepository {
    // FIXME: - 获取最新的声网RTM Token
    func agoraRTMToken(completion: @escaping AgoraTokenCompletion) {
        if let mobile = ud.userMobile {
            HomeAPI.getAgoraRtmToken(account: mobile).defaultRequest(cacheType: .ignoreCache, showError: false) { jsonData in
                if let tokenData = jsonData["data"].dictionaryObject, let token = tokenData["token"] as? String {
                    completion(token)
                }else{
                    completion("")
                }
            } failureCallback: { response in
                completion("")
            }
        }
    }
    
    func agoraRTCToken(channel: String, completion: @escaping AgoraTokenCompletion) {
        HomeAPI.getAgoraRtcToken(channel: channel).defaultRequest(cacheType: .ignoreCache, showError: false) { jsonData in
            if let tokenData = jsonData["data"].dictionaryObject, let token = tokenData["token"] as? String {
                completion(token)
            }else{
                completion("")
            }
        } failureCallback: { response in
            completion("")
        }
    }
}

// MARK: - Private
extension HomeRepository {

    func filterHomePageModules(_ unit: UnitModel) -> [HomePageFunctionModule] {
        var result = [HomePageFunctionModule]()
        let allkeys = HomePageModule.allCases
        let allModules = allkeys.compactMap { moduleEnum in
            moduleEnum.model
        }
        if let otherused = unit.otherused, otherused == 1 {
            return allModules.filter {
                $0.tag == "OTHERUSED"
            }
        } else {
            let validModules = allValidModules(unit)
            allModules.forEach { module in
                if module.showinpage == .home, !module.tag.isEmpty {
                    if validModules.contains(module.tag) {
                        result.append(module)
                    }
                }
            }
            if isMemberManagementEnable(unit) {
                result.append(HomePageModule.addFamilyMember.model)
            }
        }
        return result
    }

    private func allValidModules(_ unit: UnitModel) -> [String] {
        var result: Array<String> = []
        if unit.moudle1 == "T" {
            result.append("MOUDLE1")
        }
        if unit.moudle2 == "T" {
            result.append("MOUDLE2")
        }
        if unit.moudle3 == "T" {
            result.append("MOUDLE3")
        }
        if unit.moudle4 == "T" {
            result.append("MOUDLE4")
        }
        if unit.moudle5 == "T" {
            result.append("MOUDLE5")
        }
        if unit.moudle6 == "T" {
            result.append("MOUDLE6")
        }
        if unit.moudle7 == "T" {
            result.append("MOUDLE7")
        }
        if unit.moudle8 == "T" {
            result.append("MOUDLE8")
        }
        if unit.moudle9 == "T" {
            result.append("MOUDLE9")
        }
        // FIXME: - 暂时隐藏蓝牙配置
        if let module10 = unit.moudle10, let mobile = unit.mobile, module10.contains(mobile) {
//            result.append("MOUDLE10")
        }
        if unit.moudle11 == "T" {
            result.append("MOUDLE11")
        }
        if unit.moudle12 == "T" {
            result.append("MOUDLE12")
        }
        // FIXME: - 暂时隐藏电梯配置
        if let module13 = unit.moudle13, let mobile = unit.mobile, module13.contains(mobile) {
//            result.append("MOUDLE13")
        }
        if unit.moudle14 == "T" {
            result.append("MOUDLE14")
        }
        if unit.moudle15 == "T" {
            result.append("MOUDLE15")
        }
        if unit.moudle16 == "T" {
            result.append("MOUDLE16")
        }
        // MARK: - module17访客二维码，myset7 开门密码,根据这两个判断是否显示邀请访客功能。若只有一个开启，则点击邀请访客后，只有二维码或者密码一个对应选项。
        if unit.moudle17 == "T" {
            result.append("MOUDLE17")
        } else {
            if isVisitorPasswordEnable(unit) {
                result.append("MOUDLE17")
            }
        }
        return result
    }
}

extension HomeRepository {
    // MARK: - 添加成员是否支持
    func isMemberManagementEnable(_ unit: UnitModel) -> Bool {
        // MARK: - 当前用户在当前房屋的角色是业主，有添加成员的功能
        if let myset11 = unit.myset11, myset11 == "T", let userType = unit.usertype, userType == "O" {
            return true
        }
        return false
    }

    // MARK: - 访客密码功能是否支持
    func isVisitorPasswordEnable(_ unit: UnitModel) -> Bool {
        if let myset7 = unit.myset7, myset7 == "T" {
            return true
        }
        return false
    }

    // MARK: - 访客二维码是否支持
    func isVisitorQrCodeEnable(_ unit: UnitModel) -> Bool {
        if let module17 = unit.moudle17, module17 == "T" {
            return true
        }
        return false
    }

    // MARK: - 是否允许访客呼叫到手机
    func isVisitorCallUserMobileEnable(_ unit: UnitModel) -> Bool {
        if let myset8 = unit.myset8, myset8 == "T" {
            return true
        }
        return false
    }

    // MARK: - 人脸认证是否支持
    func isFaceCertificationEnable(_ unit: UnitModel) -> Bool {
        if let myset1 = unit.myset1, myset1 == "T" {
            return true
        }
        return false
    }
    
    //MARK: - 开门设置是否支持
    func isOpenDoorSettingEnable(_ unit: UnitModel) -> Bool {
        if let myset6 = unit.myset6, myset6 == "T" {
            return true
        }
        return false
    }

    // MARK: - 访客记录是否支持
    func isVisitorRecordEnable(_ unit: UnitModel) -> Bool {
        if isVisitorPasswordEnable(unit) {
            return true
        }
        if isVisitorQrCodeEnable(unit) {
            return true
        }
        return false
    }

    // MARK: - 户户通是否支持
    func isCallOtherUserEnable(_ unit: UnitModel) -> Bool {
        if let myset2 = unit.myset2, myset2 == "T" {
            return true
        }
        return false
    }

    // MARK: - 联系物业是否支持
    func isContactPropertyEnable(_ unit: UnitModel) -> Bool {
        if let myset9 = unit.myset9, myset9 == "T" {
            return true
        }
        return false
    }

    // MARK: - 消息是否支持
    func isNoticeMessageEnable(_ unit: UnitModel? = nil) -> Bool {
        if let unit = unit {
            if let myset4 = unit.myset4, myset4 == "T" {
                return true
            }
        } else {
            if let unit = HomeRepository.shared.getCurrentUnit(), let myset4 = unit.myset4, myset4 == "T" {
                return true
            }
        }
        return false
    }
}
