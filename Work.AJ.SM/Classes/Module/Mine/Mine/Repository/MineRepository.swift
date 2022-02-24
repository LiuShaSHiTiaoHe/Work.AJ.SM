//
//  MineRepository.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/23.
//

import UIKit

typealias HouseUpdateUnitsCompletion = ((_ errorMsg: String) -> Void)

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
