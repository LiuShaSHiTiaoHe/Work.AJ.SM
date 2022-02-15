//
//  HomeDataManager.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/8.
//

import Foundation

typealias HomeModulesCompletion = (([HomePageFunctionModule]) -> Void)

class HomeRepository {
    static let shared = HomeRepository()
    
    func allUnits(completion: @escaping HomeModulesCompletion) {
        HomeAPI.getMyUnit(mobile: Defaults.username!).request(modelType: [UnitModel].self, cacheType: .cacheElseNetwork, showError: true) { [weak self] models, response in
            guard let `self` = self else { return }
            guard models.count > 0 else {
                return
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
            RealmTools.addList(models, update: .modified) {
                logger.info("update done")
            }
        } failureCallback: { response in
            logger.info("\(response.message)")
            completion([])
        }
    }
    
    func getUnitName(unitID: Int) -> String {
        if let unit = RealmTools.objectsWithPredicate(object: UnitModel(), predicate: NSPredicate(format: "unitid == %d", unitID)).first, let communityname = unit.communityname, let cellname = unit.cellname {
            return communityname + cellname
        }
        return ""
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
            let jsonUnit = unit.toJSON()
            allModules.forEach { module in
                if !module.tag.isEmpty, module.tag != "OTHERUSED", let moduleTag = jsonUnit[module.tag] as? String, moduleTag == "T", module.showinpage == .home {
                    result.append(module)
                }
            }
        }
        return result
    }
}
