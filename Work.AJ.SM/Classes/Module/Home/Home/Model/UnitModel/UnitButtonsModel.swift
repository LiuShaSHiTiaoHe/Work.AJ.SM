//
//  UnitButtonsModel.swift
//  SmartCommunity
//
//  Created by Anjie on 2021/12/29.
//

import Foundation
import RealmSwift

class UnitButtonsModel: Object,  Mappable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var ifon: String?
    @Persisted var type: String?
    @Persisted var desc: String?
    @Persisted var title: String?
    @Persisted var realfloor: String?
    @Persisted var physicalfloor: String?
    @Persisted var provider: String?
    @Persisted(originProperty: "buttons") var assignee: LinkingObjects<UnitModel>

    ///reserved value
    @Persisted var stringValue1: String?
    @Persisted var stringValue2: String?
    @Persisted var stringValue3: String?
    @Persisted var stringValue4: String?
    @Persisted var stringValue5: String?
    @Persisted var stringValue6: String?
    @Persisted var boolValue1: Bool?
    @Persisted var boolValue2: Bool?
    @Persisted var boolValue3: Bool?
    @Persisted var boolValue4: Bool?
    @Persisted var intValue1: Int?
    @Persisted var intValue2: Int?
    @Persisted var intValue3: Int?
    @Persisted var intValue4: Int?
    
    required convenience init?(map: ObjectMapper.Map) {
      self.init()
    }
    
    // Mappable
    func mapping(map: ObjectMapper.Map) {
        ifon <- map["IFON"]
        type <- map["TYPE"]
        desc <- map["DESC"]
        title <- map["TITLE"]
        realfloor <- map["REALFLOOR"]
        physicalfloor <- map["PHYSICALFLOOR"]
        provider <- map["PROVIDER"]
    }
}
