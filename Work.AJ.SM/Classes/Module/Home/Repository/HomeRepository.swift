//
//  HomeDataManager.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/8.
//

import Foundation
import SVProgressHUD

typealias HomeModulesCompletion = (([HomePageFunctionModule]) -> Void)
typealias HomeAdsAndNoticeCompletion = (([AdsModel], [NoticeModel]) -> Void)

class HomeRepository {
    static let shared = HomeRepository()
    
    func allUnits(completion: @escaping HomeModulesCompletion) {
        SVProgressHUD.show()
        HomeAPI.getMyUnit(mobile: Defaults.username!).request(modelType: [UnitModel].self, cacheType: .networkElseCache, showError: true) { [weak self] models, response in
            SVProgressHUD.dismiss()
            guard let `self` = self else { return }
            guard models.count > 0 else {
                return
            }
            RealmTools.addList(models, update: .modified) {
                logger.info("update done")
            }
            if let currentUnitID = Defaults.currentUnitID {
                if let unit = models.first(where: { model in
                    model.unitid == currentUnitID
                }) {
                    completion(self.filterHomePageModules(unit))
                }
            }else{
                if let firstUnit = models.first, let unitID = firstUnit.unitid {
                    Defaults.currentUnitID = unitID
                    completion(self.filterHomePageModules(firstUnit))
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
            HomeAPI.getAdvertisement(operID: operID, communitID: communityID).request(modelType: [AdsModel].self) { models, response in
                adsData.append(contentsOf: models)
                group.leave()
            } failureCallback: { response in
                group.leave()
            }
            group.enter()
            HomeAPI.getNotice(communitID: communityID, blockID: blockID, cellID: cellID).request(modelType: [NoticeModel].self) { models, response in
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
        if let unit = RealmTools.objectsWithPredicate(object: UnitModel(), predicate: NSPredicate(format: "unitid == %d", unitID)).first, let communityname = unit.communityname, let cellname = unit.cellname {
            return communityname + cellname
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
                if !module.tag.isEmpty, module.tag != "OTHERUSED", let moduleTag = unit.value(forKey: module.tag.lowercased()) as? String, moduleTag == "T", module.showinpage == .home {
                    result.append(module)
                }
            }
        }
        return result
    }
}
