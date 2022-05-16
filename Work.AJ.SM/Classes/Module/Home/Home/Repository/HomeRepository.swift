//
//  HomeDataManager.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/8.
//

import Foundation
import SVProgressHUD
import JKSwiftExtension

typealias HomeModulesCompletion = (([HomePageFunctionModule]) -> Void)
typealias HomeAdsAndNoticeCompletion = (([AdsModel], [NoticeModel]) -> Void)
typealias HomeDataCompletion = (([HomePageFunctionModule], [AdsModel], [NoticeModel]) -> Void)

typealias HomeAllLocksCompletion = (([UnitLockModel]) -> Void)
typealias ElevatorConfigurationCompletion = ((ElevatorConfiguration?) -> Void)
// MARK: - NCom
typealias NComAllDeviceInfoCompletion = (([NComDTU]) -> Void)
typealias NComCallRecordCompletion = (([NComRecordInfo], Int) -> Void)

class HomeRepository {
    static let shared = HomeRepository()

    func homeData(completion: @escaping HomeDataCompletion) {
        SVProgressHUD.show()
        var homeModuleArray: Array<HomePageFunctionModule> = []
        var adsArray: Array<AdsModel> = []
        var noticeArray: Array<NoticeModel> = []
        var currentUnit: UnitModel?
        guard let userMobile = ud.userMobile else {
            SVProgressHUD.dismiss()
            completion(homeModuleArray, adsArray, noticeArray)
            return
        }
        HomeAPI.getMyUnit(mobile: userMobile).request(modelType: [UnitModel].self, cacheType: .ignoreCache, showError: true) { [weak self] models, response in
            guard let `self` = self else {
                return
            }
            guard models.count > 0 else {
                return
            }
            RealmTools.addList(models, update: .all) {
                logger.info("update done")
            }
            if let currentUnitID = Defaults.currentUnitID {
                currentUnit = models.first(where: { model in
                    model.unitid == currentUnitID
                })
                if let unit = currentUnit {
                    homeModuleArray = self.filterHomePageModules(unit)
                    self.adsAndNotice { ads, notices in
                        adsArray = ads
                        noticeArray = notices
                        completion(homeModuleArray, adsArray, noticeArray)
                    }
                } else {
                    completion(homeModuleArray, adsArray, noticeArray)
                }
            } else {
                currentUnit = models.first(where: { model in
                    model.state == "N"
                })
                if let firstUnit = currentUnit, let unitID = firstUnit.unitid {
                    Defaults.currentUnitID = unitID
                    homeModuleArray = self.filterHomePageModules(firstUnit)
                    self.adsAndNotice { ads, notices in
                        adsArray = ads
                        noticeArray = notices
                        completion(homeModuleArray, adsArray, noticeArray)
                    }
                } else {
                    completion(homeModuleArray, adsArray, noticeArray)
                }
            }
        } failureCallback: { response in
            logger.info("\(response.message)")
            completion(homeModuleArray, adsArray, noticeArray)
        }
    }

    func allUnits(completion: @escaping HomeModulesCompletion) {
        SVProgressHUD.show()
        HomeAPI.getMyUnit(mobile: Defaults.username!).request(modelType: [UnitModel].self, cacheType: .cacheThenNetwork, showError: true) { [weak self] models, response in
            SVProgressHUD.dismiss()
            guard let `self` = self else {
                return
            }
            guard models.count > 0 else {
                return
            }
            RealmTools.addList(models, update: .all) {
                logger.info("update done")
            }
            if let currentUnitID = Defaults.currentUnitID {
                if let unit = models.first(where: { model in
                    model.unitid == currentUnitID
                }) {
                    completion(self.filterHomePageModules(unit))
                }
            } else {
                if let firstUnit = models.first(where: { model in
                    model.state == "N"
                }), let unitID = firstUnit.unitid {
                    Defaults.currentUnitID = unitID
                    completion(self.filterHomePageModules(firstUnit))
                } else {
                    completion([])
                }
            }
        } failureCallback: { response in
            logger.info("\(response.message)")
            completion([])
        }
    }

    func adsAndNotice(completion: @escaping HomeAdsAndNoticeCompletion) {
        var adsData: [AdsModel] = []
        var noticeData: [NoticeModel] = []
        if let unit = getCurrentUnit(), let operID = unit.operid?.jk.intToString, let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let cellID = unit.cellid?.jk.intToString {
            SVProgressHUD.show()
            let group = DispatchGroup()
            group.enter()
            HomeAPI.getAdvertisement(operID: operID, communityID: communityID).request(modelType: [AdsModel].self) { models, response in
                adsData.append(contentsOf: models)
                group.leave()
            } failureCallback: { response in
                group.leave()
            }
            group.enter()
            HomeAPI.getNotice(communityID: communityID, blockID: blockID, cellID: cellID).request(modelType: [NoticeModel].self) { models, response in
                noticeData.append(contentsOf: models)
                group.leave()
            } failureCallback: { response in
                group.leave()
            }
            group.notify(queue: DispatchQueue.main) {
                SVProgressHUD.dismiss()
                completion(adsData, noticeData)
            }
        }
    }

    func getUnitName(unitID: Int) -> String {
        if let unit = RealmTools.objectsWithPredicate(object: UnitModel(), predicate: NSPredicate(format: "unitid == %d", unitID)).first, let communityname = unit.communityname, let cellname = unit.cellname, let blockname = unit.blockname, let unitno = unit.unitno {
            return communityname + blockname + cellname + unitno + "室"
        }
        return ""
    }

    func getCurrentUnit() -> UnitModel? {
        if let unitID = Defaults.currentUnitID {
            if let unit = RealmTools.objectsWithPredicate(object: UnitModel(), predicate: NSPredicate(format: "unitid == %d", unitID)).first {
                return unit
            }
        }
        return nil
    }

    func getCurrentUnitName() -> String {
        if let unitID = Defaults.currentUnitID {
            if let unit = RealmTools.objectsWithPredicate(object: UnitModel(), predicate: NSPredicate(format: "unitid == %d", unitID)).first, let communityname = unit.communityname, let cellname = unit.cellname {
                return communityname + cellname
            }
        }
        return ""
    }

    func getCurrentHouseName() -> String {
        if let unitID = Defaults.currentUnitID {
            if let unit = RealmTools.objectsWithPredicate(object: UnitModel(), predicate: NSPredicate(format: "unitid == %d", unitID)).first, let cell = unit.cellname, let community = unit.communityname, let unitno = unit.unitno, let blockName = unit.blockname {
                return community + blockName + cell + unitno
            }
        }
        return ""
    }

    func getCurrentUser() -> UserModel? {
        if let userID = ud.userID, let _ = userID.jk.toInt() {
            if let user = RealmTools.objectsWithPredicate(object: UserModel(), predicate: NSPredicate.init(format: "rid == %@", userID)).first {
                return user
            }
        }
        return nil
    }

    func currentUserType() -> String {
        if let unit = getCurrentUnit(), let type = unit.usertype {
            return type
        }
        return ""
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
    func getElevatorConffiguration(completion: @escaping ElevatorConfigurationCompletion) {
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

// MARK: - Private
extension HomeRepository {

    func filterHomePageModules(_ unit: UnitModel) -> [HomePageFunctionModule] {
        var result = [HomePageFunctionModule]()
        let allkeys = HomePageModule.allCases
        let allModules = allkeys.compactMap { moduleEnum in
            return moduleEnum.model
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
            // MARK: - 当前用户在当前房屋的角色是业主，有添加成员的功能
            if let userType = unit.usertype, userType == "O" {
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
    func isNoticeMessageEnable(_ unit: UnitModel) -> Bool {
        if let myset4 = unit.myset4, myset4 == "T" {
            return true
        }
        return false
    }
}
