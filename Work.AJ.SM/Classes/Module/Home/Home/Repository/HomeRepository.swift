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

