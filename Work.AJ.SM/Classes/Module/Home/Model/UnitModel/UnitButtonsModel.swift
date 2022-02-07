//
//  UnitButtonsModel.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2021/12/29.
//

import Foundation

class UnitButtonsModel: Mappable {
    var ifon: String?
    var type: String?
    var desc: String?
    var title: String?
    var realfloor: String?
    var physicalfloor: String?
    var provider: String?
    
    
    required init?(map: Map) {}
    
    // Mappable
    func mapping(map: Map) {
        ifon <- map["IFON"]
        type <- map["TYPE"]
        desc <- map["DESC"]
        title <- map["TITLE"]
        realfloor <- map["REALFLOOR"]
        physicalfloor <- map["PHYSICALFLOOR"]
        provider <- map["PROVIDER"]
    }
}
