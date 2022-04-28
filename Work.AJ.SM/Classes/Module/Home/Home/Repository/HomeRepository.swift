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
typealias HomeAllLocksCompletion = (([UnitLockModel]) -> Void)
typealias ElevatorConfigurationCompletion = ((ElevatorConfiguration?) -> Void)
// MARK: - NCom
typealias NComAllDeviceInfoCompletion = (([NComDTU]) -> Void)
typealias NComCallRecordCompletion = (([NComRecordInfo], Int) -> Void)

typealias AgoraTokenCompletion = ((String) -> Void)

class HomeRepository {
    static let shared = HomeRepository()
    
    func allUnits(completion: @escaping HomeModulesCompletion) {
        SVProgressHUD.show()
        HomeAPI.getMyUnit(mobile: Defaults.username!).request(modelType: [UnitModel].self, cacheType: .cacheThenNetwork, showError: true) { [weak self] models, response in
            SVProgressHUD.dismiss()
            guard let `self` = self else { return }
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
            }else{
                if let firstUnit = models.first(where: { model in
                    model.state == "N"
                }), let unitID = firstUnit.unitid {
                    Defaults.currentUnitID = unitID
                    completion(self.filterHomePageModules(firstUnit))
                }else{
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
            if let unit = RealmTools.objectsWithPredicate(object: UnitModel(), predicate: NSPredicate(format: "unitid == %d", unitID)).first{
                return unit
            }
        }
        return nil
    }
    
    func getCurrentUnitName() -> String {
        if let unitID = Defaults.currentUnitID {
            if let unit = RealmTools.objectsWithPredicate(object: UnitModel(), predicate: NSPredicate(format: "unitid == %d", unitID)).first, let communityname = unit.communityname, let cellname = unit.cellname{
                return communityname + cellname
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
        }else {
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
        }else {
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
                    }else{
                        completion([], -1)
                    }
                }else{
                    if let pageData = jsonData["page"].dictionaryObject, let tPage = pageData["totalPage"] as? Int  {
                        completion([], tPage)
                    }else{
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
        // MARK: - 15295776453
        completion("006b0969a21e1fb48bb89069c86f4788eabIACy7R3KDcne1NazRyvovLJcJ6VnbJypnflDqxG8YoJfuqlcGo0AAAAAEAApNZrsx0JrYgEA6APHQmti")
        // MARK: - 17834736453
//        completion("006b0969a21e1fb48bb89069c86f4788eabIACbangmidzZ3Gm74kdyI23uFsYHL2QGbJTp1mocByTBdra39t4AAAAAEAApNZrs1kJrYgEA6APWQmti")
    }
    
    func agoraRTCToken(completion: @escaping AgoraTokenCompletion) {
        // MARK: - iOSTestChannel
        completion("006b0969a21e1fb48bb89069c86f4788eabIACLIQwufRom1EnnExzqsZA6OHyD8rjZHtJ+P4bIqYcL4oGsncwAAAAAEACG8CxX/kJrYgEAAQD+Qmti")
    }
}

// MARK: - Private
extension HomeRepository {
    
    private func filterHomePageModules(_ unit: UnitModel) -> [HomePageFunctionModule]{
        var result = [HomePageFunctionModule]()
        let allkeys = HomePageModule.allCases
        let allModules = allkeys.compactMap { moduleEnum in
            return moduleEnum.model
        }
        if let otherused = unit.otherused, otherused == 1 {
            return allModules.filter {$0.tag == "OTHERUSED"}
        }else{
            allModules.forEach { module in
                if module.showinpage == .home, !module.tag.isEmpty {
                    if module.tag == "MOUDLE10" {
                        if let module10 = unit.moudle10, let mobile = unit.mobile, module10.contains(mobile) {
                            result.append(module)
                        }
                    } else if module.tag == "MOUDLE13" {
                        if let module13 = unit.moudle13, let mobile = unit.mobile, module13.contains(mobile) {
                            result.append(module)
                        }
                    } else {
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
}
