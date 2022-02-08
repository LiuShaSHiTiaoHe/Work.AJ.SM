//
//  HomeDataManager.swift
//  Work.AJ.SM
//
//  Created by Fairdesk on 2022/2/8.
//

import Foundation

class HomeDataManager {
    static let shared = HomeDataManager()
    
    func allUnits() {
        HomeAPI.getMyUnit(mobile: Defaults.username!).request(modelType: [UnitModel].self) { models, response in
            
        }
    }
    
}
