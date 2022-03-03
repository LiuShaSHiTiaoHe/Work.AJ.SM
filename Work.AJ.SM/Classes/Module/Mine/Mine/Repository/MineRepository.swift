//
//  MineRepository.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/23.
//

import UIKit

typealias HouseUpdateUnitsCompletion = ((_ errorMsg: String) -> Void)
typealias UnitMembersCompletion = (([MemberModel]) -> Void)
typealias HouseChooseCompletion = (([UnitModel]) -> Void)
typealias FaceListCompletion = (([FaceModel]) -> Void)
typealias DeleteFaceCompletion = ((_ errorMsg: String) -> Void)
typealias OwnerPasswordCompletion = ((_ errorMsg: String?) -> Void)


class MineRepository: NSObject {
    static let shared = MineRepository()

    func getAllUnits(completion: @escaping HouseUpdateUnitsCompletion) {
        SVProgressHUD.show()
        HomeAPI.getMyUnit(mobile: Defaults.username!).request(modelType: [UnitModel].self, cacheType: .networkElseCache, showError: true) { models, response in
            SVProgressHUD.dismiss()
            guard models.count > 0 else {
                completion("数据为空")
                return
            }
            RealmTools.addList(models, update: .modified) {
                logger.info("update done")
            }
            completion("")
        } failureCallback: { response in
            logger.info("\(response.message)")
            completion(response.message)
        }
    }
    
    func getAllSelectableUnit(completion: @escaping HouseChooseCompletion) {
        SVProgressHUD.show()
        HomeAPI.getMyUnit(mobile: Defaults.username!).request(modelType: [UnitModel].self, cacheType: .networkElseCache, showError: true) { models, response in
            SVProgressHUD.dismiss()
            guard models.count > 0 else {
                completion([])
                return
            }
            RealmTools.addList(models, update: .modified) {
                logger.info("update done")
            }
            
            completion(models.filter { unit in
                if let state = unit.state {
                    return state == "N"
                }else{
                    return false
                }
            })
        } failureCallback: { response in
            logger.info("\(response.message)")
            completion([])
        }
    }
    
    func getCurrentUnitMembers(completion: @escaping UnitMembersCompletion) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let userID = unit.userid?.jk.intToString, let unitID = unit.unitid?.jk.intToString {
            SVProgressHUD.show()
            MineAPI.getUnitMembers(unitID: unitID, userID: userID).defaultRequest { jsonData in
                SVProgressHUD.dismiss()
                if let memberJsonString = jsonData["data"]["users"].rawString(), let members = [MemberModel](JSONString: memberJsonString) {
                    guard members.count > 0 else { return  }
                    completion(members)
                }
            } failureCallback: { response in
                logger.info("\(response.message)")
                completion([])
            }
        }else{
            completion([])
        }
    }
    
    func getMineModules() -> [MineModule] {
        if let unit = HomeRepository.shared.getCurrentUnit() {
            let allKeys = MineModuleType.allCases
            let allModules = allKeys.compactMap {  moduleEnum in
                return moduleEnum.model
            }
            if let otherUsed = unit.otherused, otherUsed == 1 {
                return allModules.filter{$0.isOtherUsed}
            }else{
                return allModules.filter {$0.tag == mineModuleType}
            }
        }
        return []
    }
    
    func getSectionCount(_ modules: [MineModule]) -> Int {
        var destination:Set<MineModuleDestination> = []
        modules.forEach { model in
            destination.insert(model.destination)
        }
        return destination.count
    }
    
    func getRowCount(_ section: Int, _ modules: [MineModule]) -> Int {
        switch section {
        case 0:
            return modules.filter{$0.destination == .mine_0}.count
        case 1:
            return modules.filter{$0.destination == .mine_1}.count
        default:
            return 0
        }
    }
    
    func getSectionDataSource(_ indexPath: IndexPath, _ modules: [MineModule]) -> MineModule? {
        switch indexPath.section {
        case 0:
            return modules.filter{$0.destination == .mine_0}.sorted { $0.index < $1.index}[indexPath.row]
        case 1:
            return modules.filter{$0.destination == .mine_1}.sorted { $0.index < $1.index}[indexPath.row]
        default:
            return nil
        }
    }
    
}

extension MineRepository {
    func getFaceList(completion: @escaping FaceListCompletion) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let cellID = unit.cellid?.jk.intToString, let unitID = unit.unitid?.jk.intToString{
            SVProgressHUD.show()
            MineAPI.allFace(communityID: communityID, blockID: blockID, cellID: cellID, unitID: unitID).request(modelType: [FaceModel].self) { models, response in
                SVProgressHUD.dismiss()
                completion(models)
            } failureCallback: { response in
                logger.info("\(response.message)")
                completion([])
            }
        }else {
            completion([])
        }
    }
    
    func deleteFace(_ path: String, completion: @escaping DeleteFaceCompletion)  {
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let cellID = unit.cellid?.jk.intToString, let unitID = unit.unitid?.jk.intToString{
            SVProgressHUD.show()
            MineAPI.deleteFace(communityID: communityID, blockID: blockID, cellID: cellID, unitID: unitID, imagePath: path).defaultRequest { jsonData in
                completion("")
            } failureCallback: { response in
                completion(response.message)
            }
        }else {
            completion("数据完整性错误")
        }
    }
}

extension MineRepository {
    func setOwnerPassword(_ password: String, competion: @escaping OwnerPasswordCompletion) {
        if let unit = HomeRepository.shared.getCurrentUnit(), let communityID = unit.communityid?.jk.intToString, let blockID = unit.blockid?.jk.intToString, let unitID = unit.unitid?.jk.intToString, let phone = ud.userMobile, let userID = ud.userID{
            MineAPI.ownerOpenDoorPassword(communityID: communityID, unitID: unitID, blockID: blockID, userID: userID, phone: phone, openDoorPassword: password).defaultRequest { jsonData in
                competion(nil)
            } failureCallback: { response in
                competion(response.message)
            }
        }else{
            competion("参数错误")
        }
    }
}
