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

class HomeRepository {
    static let shared = HomeRepository()
    private init(){}
}

// MARK: - ModuleStatusControlData
extension HomeRepository {
    // MARK: - 获取服务器根据版本控制的模块功能开关数据并缓存
    func getModuleStatusFromServer() {
        logger.info("获取服务器根据版本控制的模块功能开关数据并缓存")
        if let unitID = ud.currentUnitID?.jk.intToString, let communityID = ud.currentCommunityID?.jk.intToString, let userID = ud.userID {
            HomeAPI.getModuleStatusByVersion(unitID: unitID, communityID: communityID, userID: userID).request(modelType: ModuleStatusByVersion.self, cacheType: .ignoreCache, showError: false) { model, response in
                if model.isNotEmpty() {
                    let moduleStatusDictionary = model.getModuleDictionary()
                    CacheManager.version.saveCacheWithDictionary(moduleStatusDictionary as NSDictionary, key: "ModuleStatus")
                    ud.getModuleStatusDate = Date()
                }
            }
        }
    }
    // MARK: - 从缓存中获取模块控制开关数据，如果没有就去服务器请求，直接返回TRUE，不影响体验
    func getModuleStatusFromCache(module: ModulesOfModuleStatus) -> Bool {
        let moduleStatusDictionary = CacheManager.version.fetchCachedWithKey("ModuleStatus")
        if let moduleStatusDictionary = moduleStatusDictionary, moduleStatusDictionary.count > 0, let status = moduleStatusDictionary[module.rawValue] as? Bool {
            //本地缓存的记录，超过设置的时间间隔，要去服务器重新请求数据，这次依旧返回缓存的状态
            if !isModuleStatusCacheWithinTheExpirationDate() {
                logger.info("本地缓存的记录，超过设置的时间间隔，要去服务器重新请求数据，这次依旧返回缓存的状态")
                getModuleStatusFromServer()
            } else {
                logger.info("本地缓存的记录，没有超过设置的时间间隔，返回缓存的状态")
            }
            return status
        } else {
            getModuleStatusFromServer()
        }
        return true
    }
    
    private func isModuleStatusCacheWithinTheExpirationDate() -> Bool{
        if let lastGetModuleStatusDate = ud.getModuleStatusDate, let intervalMinites = lastGetModuleStatusDate.jk.numberOfMinutes(from: Date()) {
            logger.info("距离上次获取模块控制信息已经: \(abs(intervalMinites)) 分钟")
            if abs(intervalMinites) < kModuleStatusTimeInterval {
               return true
            }
        }
        return false
    }
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
                    }
            )
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
        if let userID = ud.userID, let unit = getCurrentUnit(), let physicalFloor = unit.physicalfloor,
            let communityID = unit.communityid?.jk.intToString, let unitID = unit.unitid?.jk.intToString,
            let blockID = unit.blockid?.jk.intToString, let cellID = unit.cellid?.jk.intToString {
            HomeAPI.openDoor(lockMac: lockMac, userID: userID, communityID: communityID,
                             blockID: blockID, unitID: unitID, cellID: cellID,
                             physicalFloor: physicalFloor)
            .defaultRequest { jsonData in
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

extension HomeRepository {
    // MARK: - 暂时选择无TOKEN的方式，不与服务器有交互
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

