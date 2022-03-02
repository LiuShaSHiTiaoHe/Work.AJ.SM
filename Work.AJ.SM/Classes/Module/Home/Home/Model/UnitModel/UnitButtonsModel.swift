//
//  UnitButtonsModel.swift
//  SmartCommunity
//
//  Created by Fairdesk on 2021/12/29.
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
    @Persisted var reservedString1: String?
    @Persisted var reservedString2: String?
    @Persisted var reservedString3: String?
    @Persisted var reservedString4: String?
    @Persisted var reservedBool1: Bool = false
    @Persisted var reservedBool2: Bool = false
    @Persisted var reservedInt1: Int
    @Persisted var reservedInt2: Int
    
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
